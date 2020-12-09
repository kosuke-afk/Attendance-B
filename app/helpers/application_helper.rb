module ApplicationHelper
    
 def title_name(page_name = "")
   base_title = "勤怠システム"
   if page_name.nil?
       base_title
   else
     page_name + "|" + base_title
   end
 end
 
 
end
