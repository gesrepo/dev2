//Generated by wsdl2apex

public class schemasMicrosoftCom200310Serializat {
    public class ArrayOfstring {
        
        public String[] string_x;
        @TestVisible
        private String[] string_x_type_info = new String[]{'string','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'0','-1','true'};
        @TestVisible
        private String[] apex_schema_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays','true','false'};
        @TestVisible
        private String[] field_order_type_info = new String[]{'string_x'};
    }
    public class KeyValueOfstringstring_element {
        public String Key;
        public String Value;
        @TestVisible
        private String[] Key_type_info = new String[]{'Key','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'1','1','true'};
        @TestVisible
        private String[] Value_type_info = new String[]{'Value','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'1','1','true'};
        @TestVisible
        private String[] apex_schema_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays','true','false'};
        @TestVisible
        private String[] field_order_type_info = new String[]{'Key','Value'};
    }
    public class ArrayOfKeyValueOfstringstring {
        public schemasMicrosoftCom200310Serializat.KeyValueOfstringstring_element[] KeyValueOfstringstring;
        @TestVisible
        private String[] KeyValueOfstringstring_type_info = new String[]{'KeyValueOfstringstring','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'0','-1','false'};
        @TestVisible
        private String[] apex_schema_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays','true','false'};
        @TestVisible    
        private String[] field_order_type_info = new String[]{'KeyValueOfstringstring'};
    }
   public class ArrayOfint {
        public Integer[] int_x;
        @TestVisible
        private String[] int_x_type_info = new String[]{'int','http://schemas.microsoft.com/2003/10/Serialization/Arrays',null,'0','-1','false'};
        @TestVisible
        private String[] apex_schema_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays','true','false'};
        @TestVisible
        private String[] field_order_type_info = new String[]{'int_x'};
    }
}