@isTest
public class schemasDatacontractOrg200407ViadSeTest {
        public Boolean Available;
        public Integer ItemId;
        public Integer StockLevel;
        Private Static String[] Available_type_info;
        Private Static String[] ItemId_type_infol;
        Private Static String[] StockLevel_type_info;
        Private Static String[] apex_schema_type_info;
        Private Static String[] field_order_type_info;
        Private Static String[] ProductStock_type_info;
    @isTest    
      Private Static void  ProductStock() {
         schemasDatacontractOrg200407ViadSe.ProductStock productStock = new schemasDatacontractOrg200407ViadSe.ProductStock();
         productStock.Available_type_info = new String[]{'Available','http://schemas.datacontract.org/2004/07/Viad.Services.Public.GES.v1.DataContracts.Show',null,'0','1','false'}; 
         productStock.ItemId_type_info = new String[]{'ItemId','http://schemas.datacontract.org/2004/07/Viad.Services.Public.GES.v1.DataContracts.Show',null,'0','1','false'};
         productStock.StockLevel_type_info = new String[]{'StockLevel','http://schemas.datacontract.org/2004/07/Viad.Services.Public.GES.v1.DataContracts.Show',null,'0','1','true'};    
         productStock.apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/Viad.Services.Public.GES.v1.DataContracts.Show','true','false'};    
         productStock.field_order_type_info = new String[]{'Available','ItemId','StockLevel'};   
       }
    
    @isTest 
    Private static void ArrayOfProductStock() {
        schemasDatacontractOrg200407ViadSe.ProductStock arrayproductStock = new schemasDatacontractOrg200407ViadSe.ProductStock();
        schemasDatacontractOrg200407ViadSe.ArrayOfProductStock arrayproductStock1 = new schemasDatacontractOrg200407ViadSe.ArrayOfProductStock();
        arrayproductStock1.ProductStock_type_info = new String[]{'ProductStock','http://schemas.datacontract.org/2004/07/Viad.Services.Public.GES.v1.DataContracts.Show',null,'0','-1','true'};
        arrayproductStock1.apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/Viad.Services.Public.GES.v1.DataContracts.Show','true','false'};
        arrayproductStock1.field_order_type_info = new String[]{'ProductStock'};
    }
    
}