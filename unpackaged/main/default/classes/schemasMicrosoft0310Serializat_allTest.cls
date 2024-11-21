@isTest
public class schemasMicrosoft0310Serializat_allTest {
   
    public Integer[] int_x;
    public String[] string_x;
    public String Key;
    public String Value;
    public String[] KeyValueOfstringstring;
    Private Static String[] string_x_type_info;
    Private Static String[] int_x_type_info;
    Private Static String[] apex_schema_type_info;
    private Static String[] field_order_type_info;
    private Static String[] Key_type_info;
    private Static String[] Value_type_info;
    private Static String[] KeyValueOfstringstring_type_info;
  
    @isTest
   Private static void ArrayOfstring(){
        schemasMicrosoft0310Serializat_all.ArrayOfstring k4 = new schemasMicrosoft0310Serializat_all.ArrayOfstring();
        k4.string_x_type_info = new String[]{'Aish','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'0','-1','true'};
        k4.apex_schema_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays','true','false'};
        k4.field_order_type_info = new String[]{'string_x'}; 

    }
   @isTest
   Private Static void KeyValueOfstringstring_element(){
     schemasMicrosoft0310Serializat_all.KeyValueOfstringstring_element kt = new schemasMicrosoft0310Serializat_all.KeyValueOfstringstring_element();
     kt.Key_type_info = new String[]{'Sfdc','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'1','1','true'};
     kt.Value_type_info = new String[]{'123','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'1','1','true'};
     kt.apex_schema_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays','true','false'};
     kt.field_order_type_info = new String[]{'Key','Value'};
    }
   @isTest
     Private Static void ArrayOfKeyValueOfstringstring(){
     
        schemasMicrosoft0310Serializat_all.KeyValueOfstringstring_element kt2 = new schemasMicrosoft0310Serializat_all.KeyValueOfstringstring_element();
        schemasMicrosoft0310Serializat_all.ArrayOfKeyValueOfstringstring kt1 = new schemasMicrosoft0310Serializat_all.ArrayOfKeyValueOfstringstring();
        kt1.KeyValueOfstringstring_type_info = new String[]{'SFDC','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'0','-1','false'};
        kt1.apex_schema_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays','true','false'};
        kt1.field_order_type_info = new String[]{'KeyValueOfstringstring'};
    }
    @isTest
    Private static void ArrayOfint(){
        schemasMicrosoft0310Serializat_all.ArrayOfint k5 = new  schemasMicrosoft0310Serializat_all.ArrayOfint();
        k5.int_x_type_info= new String[]{'21','http://schemas.microsoft.com/2003/10/Serialization/Arrays','21','0','-1','false'};
        k5.apex_schema_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays','true','false'};
        k5.field_order_type_info = new String[]{'string_x'};
     }
    
 }