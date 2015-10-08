module ApplicationHelper
    # is the current member admin
    def is_admin?
        if signed_in?
            current_user.admin?
        else
            false
        end
    end
    
    # Return the full title of page
    def full_title(page_title)
        base_title = "StackTwitter"
        if page_title.empty?
            return base_title
        else
            return "#{base_title} | #{page_title}"
        end
    end

    def required_label(field, text, tooltip_text = '')

        label_text = "#{text} &nbsp;<span class=\"required-indicator\">*</span>"

        unless tooltip_text.blank?
            label_text = label_text + "<span class=\"question\ tooltip_target\" title=\"#{tooltip_text}\">?</span>"
        end

        label_tag field, raw(label_text), class: 'form-title col-sm-3 col-xs-12'
    end

end
