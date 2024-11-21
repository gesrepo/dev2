public class OpportunityProducts_CheckDelete
{
   private ApexPages.StandardController stdCtrl;

   public OpportunityProducts_CheckDelete(ApexPages.StandardController std)
   {
      stdCtrl=std;
   }

   public PageReference checkDelete()
   {
      System.Debug(userinfo.getProfileId());
      OpportunityLineItem product = (OpportunityLineItem)stdCtrl.getRecord();
      
      System.Debug(product.Opportunity.RecordType.DeveloperName);
       
      //Filter by profile
      /*
      Profile p = [select id,Name from Profile where id=:Userinfo.getProfileid()];
      System.Debug(p.Name);
      if(p.Name  == 'EMEA System Administrator')
      */      
      
      System.Debug('Record type name: ' + product.Opportunity.RecordType.DeveloperName);
      
      //Filter by recordType
      if(product.Opportunity.RecordType.DeveloperName == 'EMEA_Poken_and_Visit')
      {
         System.Debug(product.Id);
         System.Debug(product.OpportunityId);
         
         //This delete didn't work :(
         //stdCtrl.delete();
         
         delete product;

         return new PageReference('/' + product.OpportunityId);
      }
      else
      {
         return null;
      }
   }
}