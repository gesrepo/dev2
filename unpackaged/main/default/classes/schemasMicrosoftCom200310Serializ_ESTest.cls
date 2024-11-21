/**************************************
Author          : Mohd Sajid
Release         : April 18, 2023
Created         : April 10, 2023
Functionality   : this class covers to schemasMicrosoftCom200310Serializat_ES
Itrack#   		: sfdc-202

Modification History:
Itrack#        Date                Author                         Change  
****************************************************************************

***********************************************************************************/
@isTest
public class schemasMicrosoftCom200310Serializ_ESTest {

    public String[] string_x;
    public String Key;
    public String Value;
    public String[] KeyValueOfstringstring;
    Private Static String[] string_x_type_info;
    Private Static String[] apex_schema_type_info;
    private Static String[] field_order_type_info;
    private Static String[] Key_type_info;
    private Static String[] Value_type_info;
    private Static String[] KeyValueOfstringstring_type_info;
  
    @isTest
   Private static void ArrayOfstring(){
     schemasMicrosoftCom200310Serializat_ES.ArrayOfstring k4 = new schemasMicrosoftCom200310Serializat_ES.ArrayOfstring();
     k4.string_x_type_info = new String[]{'Aish','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'0','-1','true'};
     k4.apex_schema_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays','true','false'};
     k4.field_order_type_info = new String[]{'string_x'}; 
    }
   @isTest
   Private Static void KeyValueOfstringstring_element(){
     schemasMicrosoftCom200310Serializat_ES.KeyValueOfstringstring_element kt = new schemasMicrosoftCom200310Serializat_ES.KeyValueOfstringstring_element();
     kt.Key_type_info = new String[]{'Sfdc','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'1','1','true'};
     kt.Value_type_info = new String[]{'123','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'1','1','true'};
     kt.apex_schema_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays','true','false'};
     kt.field_order_type_info = new String[]{'Key','Value'};
    }
   @isTest
   Private Static void ArrayOfKeyValueOfstringstring(){     
     schemasMicrosoftCom200310Serializat_ES.KeyValueOfstringstring_element kt2 = new schemasMicrosoftCom200310Serializat_ES.KeyValueOfstringstring_element();
     schemasMicrosoftCom200310Serializat_ES.ArrayOfKeyValueOfstringstring kt1 = new schemasMicrosoftCom200310Serializat_ES.ArrayOfKeyValueOfstringstring();
     kt1.KeyValueOfstringstring_type_info = new String[]{'SFDC','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'0','-1','false'};
     kt1.apex_schema_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays','true','false'};
     kt1.field_order_type_info = new String[]{'KeyValueOfstringstring'};
    }
   @isTest
   Private static void ArrayOfint(){
     schemasMicrosoftCom200310Serializat_ES.ArrayOfint k4 = new schemasMicrosoftCom200310Serializat_ES.ArrayOfint();
     k4.int_x_type_info = new String[]{'Aish','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'0','-1','true'};
     k4.apex_schema_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays','true','false'};
     k4.field_order_type_info = new String[]{'int_x'}; 
    } 
    
}