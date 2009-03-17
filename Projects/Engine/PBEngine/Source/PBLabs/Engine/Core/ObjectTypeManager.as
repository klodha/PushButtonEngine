package PBLabs.Engine.Core
{
   import PBLabs.Engine.Debug.Logger;
   
   import flash.utils.Dictionary;
   
   /**
    * The ObjectTypeManager, together with the ObjectType class, is essentially an abstraction
    * of a bitmask to allow objects to be identified with friendly names, rather than complicated
    * numbers.
    * 
    * @see ObjectType
    * @see ../../../../../Examples/ObjectTypes.html Using Object Types 
    */
   public class ObjectTypeManager
   {
      /**
       * The singleton ObjectTypeManager instance.
       */
      public static function get Instance():ObjectTypeManager
      {
         if (_instance == null)
            _instance = new ObjectTypeManager();
         
         return _instance;
      }
      
      private static var _instance:ObjectTypeManager = null;
      
      /**
       * The number of object types that have been registered.
       */
      public function get TypeCount():uint
      {
         return _typeCount;
      }
      
      /**
       * Gets the number associated with a specified object type, registering it if
       * necessary.
       * 
       * @param typeName The name of the object type to retrieve.
       * 
       * @return The number associated with the specified type.
       */
      public function GetType(typeName:String):uint
      {
         if (_typeList[typeName] == null)
         {
            if (_typeCount == 64)
            {
               Logger.PrintWarning(this, "GetObjectType", "Only 64 unique object types can be created.");
               return 0;
            }
            
            _typeList[typeName] = _typeCount;
            _bitList[1 << _typeCount] = typeName;
            _typeCount++;
         }
         
         return 1 << _typeList[typeName];
      }
      
      /**
       * Gets the name of an object type based on the number it was assigned.
       * 
       * @param number The number of the type to find.
       * 
       * @return The name of the type with the specified number, or null if 
       * the number is not assigned to any type.
       */
      public function GetTypeName(number:uint):String
      {
         return _bitList[number];
      }
      
      /**
       * Determines whether an object type is of the specified type.
       * 
       * @param type The type to check.
       * @param typeName The name of the type to check.
       * 
       * @return True if the specified type is of the specified type name. Keep in
       * mind, the type must match exactly, meaning, if it has multiple type names
       * associated with it, this will always return false.
       * 
       * @see #DoesTypeOverlap()
       */
      public function DoesTypeMatch(type:ObjectType, typeName:String):Boolean
      {
         return type.Bits == (1 << _typeList[typeName]);
      }
      
      /**
       * Determines whether an object type contains the specified type.
       * 
       * @param type The type to check.
       * @param typeName The name of the type to check.
       * 
       * @return True if the specified type is of the specified type name. Keep in
       * mind, the type must only contain the type name, meaning, if it has multiple
       * type names associated with it, only one of them has to match.
       * 
       * @see #DoesTypeMatch()
       */
      public function DoesTypeOverlap(type:ObjectType, typeName:String):Boolean
      {
         return (type.Bits & (1 << _typeList[typeName])) != 0;
      }
      
      /**
       * Determines whether two object types are of the same type.
       * 
       * @param type1 The type to check.
       * @param type2 The type to check against.
       * 
       * @return True if type1 and type2 contain the exact same types.
       */
      public function DoTypesMatch(type1:ObjectType, type2:ObjectType):Boolean
      {
         return type1.Bits == type2.Bits;
      }
      
      /**
       * Determines whether two object types have overlapping types.
       * 
       * @param type1 The type to check.
       * @param type2 The type to check against.
       * 
       * @return True if type1 has any of the type contained in type2.
       */
      public function DoTypesOverlap(type1:ObjectType, type2:ObjectType):Boolean
      {
         if (!type1 || !type2)
            return false;
         
         return (type1.Bits & type2.Bits) != 0;
      }
      
      private var _typeCount:uint = 0;
      private var _typeList:Dictionary = new Dictionary();
      private var _bitList:Array = new Array();
   }
}