script "Global_RevealJS_Menu"
--> MetaData
-
license: GPLv3
name: Global_RevealJS_Menu
type: controller
version: 0.4


--> Global | RevealJS | Menu
-
on submenu_Assets
   return "Global | View | Assets | Menu"
end submenu_Assets

on menu_TestJavascript templateView, doWhat
   switch doWhat
      case "start"
         put "Reveal.slide( 0 );" into someJavascript
         break
      case "first"
         put "Reveal.slide( 1 );" into someJavascript
         break
      case "-"
      case "right"
         put "Reveal.right();" into someJavascript
         break
      case "left"
         put "Reveal.left();" into someJavascript
         break
      case "overview"
         put "Reveal.toggleOverview();" into someJavascript
         break
      case "-"
      case "autoslide"
         put "Reveal.toggleAutoSlide( true );" into someJavascript
         break
      case "pause"
         put "Reveal.togglePause( false );" into someJavascript
         break
   end switch
   
   put the long id of control 1 of cd 1 of stack "View|RevealJS" into browserWidget
   do someJavascript in browserWidget
end menu_TestJavascript

on _
end _

on menu_OnlineDecks templateView, whichURL
   switch whichURL
      case "revealjs"
         put "http://lab.hakim.se/reveal-js/#/" into someURL
         break
      case "mine"
         put "https://slides.com/davidbovill/hello-world/live" into someURL
         break
      case "CSS"
         put "http://razvancaliman.com/fowd-london-2014/" into someURL
         break
      case "-"
      case "empty"
         put empty into someURL
         break
   end switch
   put the long id of control 1 of cd 1 of stack "View|RevealJS" into browserView
   set the url of browserView to someURL
end menu_OnlineDecks

on _
end _

on menu_DownloadRevealJs templateView
   put the project_Name of templateView into projectName
   lcw_Answer "Sure you want to trash the asset folder for project '[[projectName]]' and replace it with the assets from reveal.js on GitHub?"
   
   put the project_AssetFolder of templateView into assetFolder
   git_CloneAndReplaceFolder "git@github.com:hakimel/reveal.js.git", assetFolder
end menu_DownloadRevealJs

on menu_LaunchDocumentation
   launch url "https://github.com/hakimel/reveal.js/"
end menu_LaunchDocumentation

on menu_RevealAssetFolder templateView
   put the project_AssetFolder of templateView into assetFolder
end menu_RevealAssetFolder

on menu_CreateAssetFolder templateView
   put the project_AssetFolder of templateView into assetFolder
   folder_CreateNested assetFolder
   finder_Reveal assetFolder
end menu_CreateAssetFolder


--> Global | RevealJS | Menu | Props
-
getprop short_AssetFiles [templateView]
   put the project_ShortAssetFiles of templateView into shortFiles
   return shortFiles
end short_AssetFiles


--> Global | RevealJS | Menu | Disabled
-
getprop disabled_RevealAssetFolder [templateView]
   put the project_AssetFolder of templateView into assetFolder
   if there is a folder assetFolder then
      return false
   else
      return "delete"
   end if
end disabled_RevealAssetFolder

getprop disabled_CreateAssetFolder [templateView]
   put the project_AssetFolder of templateView into assetFolder
   if there is a folder assetFolder then
      return "delete"
   else
      return false
   end if
end disabled_CreateAssetFolder
