public class RedirectToDiscountEditPage {
    public PageReference result{set;get;}
    public  RedirectToDiscountEditPage(ApexPages.StandardController controller){
        result=new PageReference('/apex/NewDiscountFromBoothArea');
        String discountId=controller.getId();
        List<Discount__c> gc=[select Booth_Area__r.Id from Discount__c where id =: controller.getId() limit 1];
        result.getParameters().put('Id',gc.get(0).Booth_Area__c);
        result.getParameters().put('discountId', discountId);
        result.setRedirect(true);
    }
    public PageReference navigate(){
        return result;
    }
}