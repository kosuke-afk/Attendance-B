module ApplicationHelper
    
 def title_name(page_name = "")
   base_title = "Attendance App"
   if page_name.nil?
       base_title
   else
     page_name + "|" + base_title
   end
 end
end
