/**Method of ProductHandler*/
public with sharing class ProductHandler{
    
    /**ProductHandler Constructor*/
    public ProductHandler(){
        //Call your helper class
    }
    
    /**Call your helper class for Before Insert*/
    public void onBeforeInsert(Product2[] newProduct2s){
        //Call your helper class
    }
    
    /**Call your helper class for After Insert*/
    public void onAfterInsert(Product2[] newProduct2s){
        //Call your helper class
    }
    
    /**Call your helper class for Before Update*/
    public void onBeforeUpdate(Map<Id, Product2> oldProduct2Map,  Map<Id, Product2> newProduct2Map){
        //Call your helper class
        //ProductBL.updateTargetIO(newProduct2Map.values());
        //ProductBL.updateTargetOI(oldProduct2Map.values(), newProduct2Map.values());
    }
    
    /**Call your helper class for After Update*/
    public void onAfterUpdate(Map<Id, Product2> oldProduct2Map,  Map<Id, Product2> newProduct2Map){
        //Call your helper class
        ProductBL.updateTargetOI(oldProduct2Map.values(), newProduct2Map.values());
    }
    
    /**Call your helper class for Before Delete*/
    public void onBeforeDelete(Product2[] product2sToDelete, Map<ID, Product2> product2Map){
        //Call your helper class
    }
    
    /**Call your helper class for After Delete*/
    public void onAfterDelete(Product2[] deletedProduct2s, Map<ID, Product2> product2Map){
        //Call your helper class
    }
    
    /**Call your helper class for Undelete*/
    public void onUndelete(Product2[] restoredProduct2s){
        
    }
}