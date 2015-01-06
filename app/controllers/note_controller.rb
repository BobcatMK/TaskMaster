class NoteController < ApplicationController

    include ApplicationHelper

    def note_show
        @all_notes = Note.where(:user_id => current_user.id)
        @all_folders = Folder.where(:user_id => current_user.id)

        respond_to do |format|
            format.js { render "note_show.js.erb" }
        end
    end

    def folder_add_get
        @new_folder = Folder.new

        respond_to do |format|
            format.js { render "folder_add_get.js.erb" }
        end
    end

    def folder_add_get_initial
        @new_folder = Folder.new

        respond_to do |format|
            format.js { render "folder_add_get_initial.js.erb" }
        end        
    end

    def folder_add
        @new_folder = Folder.new(
            :title => params[:folder][:title],
            :user_id => params[:folder][:user_id]
        )

        @all_notes = Note.where(:user_id => current_user.id)
        @all_folders = Folder.where(:user_id => current_user.id)

        if @new_folder.save
            @all_notes = Note.where(:user_id => current_user.id)
            @all_folders = Folder.where(:user_id => current_user.id)
            respond_to do |format|
                format.js { render "note_show.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "folder_add_fail.js.erb" }
            end            
        end
    end

    def folder_add_initial
        @new_folder = Folder.new(
            :title => params[:folder][:title],
            :user_id => params[:folder][:user_id]
        )

        @all_notes = Note.where(:user_id => current_user.id)
        @all_folders = Folder.where(:user_id => current_user.id)

        if @new_folder.save
            @all_notes = Note.where(:user_id => current_user.id)
            @all_folders = Folder.where(:user_id => current_user.id)
            respond_to do |format|
                format.js { render "note_show.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "folder_add_fail_initial.js.erb" }
            end            
        end
    end

    def folder_show_files
        @this_folder = Folder.find(params[:folder_id])

        respond_to do |format|
            format.js { render "folder_show_files.js.erb" }
        end
    end

    def note_add_get
        @this_folder = Folder.find(params[:folder_id])

        @new_note = Note.new

        @all_folders = Folder.where(:user_id => current_user.id)

        respond_to do |format|
            format.js { render "note_add_get.js.erb" }
        end
    end

    def folder_nil
        respond_to do |format|
            format.js { render "folder_nil.js.erb" }
        end
    end

    def note_add
        @new_note = Note.new(
            :title => params[:note][:title],
            :user_id => params[:note][:user_id],
            :content => params[:note][:content],
            :folder_id => params[:note][:folder_id]
        )

        @owning_folder = Folder.find(params[:note][:folder_id])

        if @new_note.save
            @all_notes = Note.where(:user_id => current_user.id)
            @all_folders = Folder.where(:user_id => current_user.id)

            @flash_notice = "You have added note '#{@new_note.title}' to '#{@owning_folder.title}'"

            respond_to do |format|
                format.js { render "note_show.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "note_add_fail.js.erb" }
            end
        end
    end

    def note_browse
        @this_note = Note.find(params[:note_id])

        respond_to do |format|
            format.js { render "note_browse.js.erb" }
        end
    end

    def note_edit_content_get
        @this_note = Note.find(params[:note_id])

        respond_to do |format|
            format.js { render "note_edit_content_get.js.erb" }
        end
    end

    def note_edit_content
        @this_note = Note.find(params[:note][:id])

        if @this_note.update(:content => params[:note][:content],:user_id => current_user.id)
            respond_to do |format|
                format.js { render "note_edit_content_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "note_edit_content_fail.js.erb"}
            end
        end
    end

    def note_edit_rest_get
        @this_note = Note.find(params[:note_id])
        @all_folders = Folder.where(:user_id => current_user.id)

        respond_to do |format|
            format.js { render "note_edit_rest_get.js.erb" }
        end
    end

    def note_edit_rest
        @this_note = Note.find(params[:note][:id])
        @all_folders = Folder.where(:user_id => current_user.id)

        if @this_note.update(:folder_id => params[:note][:folder_id],:title => params[:note][:title])
            @this_folder = Folder.find(@this_note.folder_id)

            respond_to do |format|
                format.js { render "note_edit_rest_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "note_edit_rest_fail.js.erb" }
            end
        end
    end

    def note_delete
        @this_note = Note.find(params[:note_id])
        @this_folder = Folder.find(@this_note.folder_id)
        @all_folders = Folder.where(:user_id => current_user.id)
        
        @this_note.destroy

        respond_to do |format|
            format.js { render "note_delete.js.erb" }
        end
    end

    def folder_edit_get
        @all_folders = Folder.where(:user_id => current_user.id)

        respond_to do |format|
            format.js { render "folder_edit_get.js.erb" }
        end
    end

    def folder_edit
        @this_folder = Folder.find(params[:folder][:id])
        @all_folders = Folder.where(:user_id => current_user.id)

        if @this_folder.update(:title => params[:folder][:title])
            @flash_message = "You have successfully updated folder"
            respond_to do |format|
                format.js { render "folder_edit_success.js.erb"}
            end
        else
            respond_to do |format|
                format.js { render "folder_edit_fail.js.erb"}
            end
        end
    end

    def folder_delete
        @folder_to_del = Folder.find(params[:folder_id])
        @folder_id_nr = params[:folder_id]

        @folder_to_del.destroy

        respond_to do |format|
            format.js { render "folder_delete.js.erb" }
        end
    end

    def send_note_via_email_get
        @this_note_id = params[:note_id]

        respond_to do |format|
            format.js { render "send_note_via_email_get.js.erb" }
        end
    end

    def send_note_via_email
        @this_note = Note.find(params[:note_id])

        @sendnote = Sendnote.new(
            :sender_name => params[:sendnote][:sender_name],
            :sender_email => params[:sendnote][:sender_email],
            :receiver_email => params[:sendnote][:receiver_email]
        )

        if @sendnote.valid?
            
            Mailer.send_note_via_email(@sendnote,@this_note).deliver

            respond_to do |format|
                format.js { render "send_note_via_email_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "send_note_via_email_fail.js.erb" }
            end
        end
    end
end
