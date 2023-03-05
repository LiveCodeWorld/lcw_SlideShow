script "behavior_ViewRevealJS"
--> MetaData
-
license: GPLv3
name: behavior_ViewRevealJS
type: behavior
version: 0.1


--> Events
-
on preOpenControl
   if exists (stack "behavior_ViewBrowser") then
      put the name of stack "behavior_ViewBrowser" into bObject
      set the behavior of stack "behavior_ViewRevealJS" to bObject
   end if
end preOpenControl


