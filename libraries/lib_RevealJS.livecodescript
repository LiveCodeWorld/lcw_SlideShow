script "lib_RevealJS"
--> MetaData
-
license: GPLv3
name: lib_RevealJS
type: library
version: 0.1


--> Events | Slideshow
-
on reveal_SlideChanged slideJson
   put the long id of the target into browserView
   
   put jsonImport (slideJson) into slideArray
   -- display_Array slideArray
   put slideArray ["h"] + 1 into horizontalSlideNum
   put slideArray ["v"] + 1 into verticalSlideNum
   
   switch horizontalSlideNum
      case 1
         put empty into someColour
         break
      case 2
         put "red" into someColour
         break
      default
         put colour_GetRandom() into someColour
   end switch
   
   put the card_Object of browserView into cardObject
   set the backgroundcolor of cardObject to someColour
end reveal_SlideChanged
