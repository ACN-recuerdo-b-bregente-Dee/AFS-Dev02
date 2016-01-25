/**
     * CloudAlley CodeCoverage+
     *
     * Parsing JSON Data.
     *
     * Author: J.D. Hugger
     * Version: 1.2
     * Date: 3/6/2014
     */
public class J2A_ApexCodeCoverageAggregate {
 
    public class Attributes {
        public String type;
        public String url;
    }
 
    public class Records {
        public Attributes attributes;
        public String Id;
        public String ApexClassOrTriggerId;
        public Integer NumLinesCovered;
        public Integer NumLinesUncovered;
    }
 
    public Integer size;
    public Integer totalSize;
    public Boolean done;
    public Object queryLocator;
    public List<Records> records;
    public String entityTypeName;
 
    public static J2A_ApexCodeCoverageAggregate parse(String json) {
        return (J2A_ApexCodeCoverageAggregate) System.JSON.deserialize(json, J2A_ApexCodeCoverageAggregate.class);
    }
     
    /**
    static testMethod void testParse() {
        String json = '{\"size\":17,\"totalSize\":17,\"done\":true,\"queryLocator\":null,\"records\":[{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA1IAO\"},\"Id\":\"715L0000000ANA1IAO\",\"ApexClassOrTriggerId\":\"01pa0000001pXO2AAM\",\"NumLinesCovered\":7,\"NumLinesUncovered\":0},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA2IAO\"},\"Id\":\"715L0000000ANA2IAO\",\"ApexClassOrTriggerId\":\"01pa0000001pXO1AAM\",\"NumLinesCovered\":9,\"NumLinesUncovered\":0},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA3IAO\"},\"Id\":\"715L0000000ANA3IAO\",\"ApexClassOrTriggerId\":\"01pL00000005aILIAY\",\"NumLinesCovered\":22,\"NumLinesUncovered\":0},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA4IAO\"},\"Id\":\"715L0000000ANA4IAO\",\"ApexClassOrTriggerId\":\"01pL00000005ZCqIAM\",\"NumLinesCovered\":15,\"NumLinesUncovered\":0},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA5IAO\"},\"Id\":\"715L0000000ANA5IAO\",\"ApexClassOrTriggerId\":\"01p30000000YjJDAA0\",\"NumLinesCovered\":87,\"NumLinesUncovered\":6},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA6IAO\"},\"Id\":\"715L0000000ANA6IAO\",\"ApexClassOrTriggerId\":\"01p30000000YWsEAAW\",\"NumLinesCovered\":101,\"NumLinesUncovered\":13},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA7IAO\"},\"Id\":\"715L0000000ANA7IAO\",\"ApexClassOrTriggerId\":\"01p30000000aoWAAAY\",\"NumLinesCovered\":174,\"NumLinesUncovered\":0},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA8IAO\"},\"Id\":\"715L0000000ANA8IAO\",\"ApexClassOrTriggerId\":\"01p30000000ZurzAAC\",\"NumLinesCovered\":169,\"NumLinesUncovered\":11},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA9IAO\"},\"Id\":\"715L0000000ANA9IAO\",\"ApexClassOrTriggerId\":\"01pL00000005ZDAIA2\",\"NumLinesCovered\":67,\"NumLinesUncovered\":74},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANAAIA4\"},\"Id\":\"715L0000000ANAAIA4\",\"ApexClassOrTriggerId\":\"01pL00000005YKAIA2\",\"NumLinesCovered\":191,\"NumLinesUncovered\":16},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANABIA4\"},\"Id\":\"715L0000000ANABIA4\",\"ApexClassOrTriggerId\":\"01pL00000005YJlIAM\",\"NumLinesCovered\":86,\"NumLinesUncovered\":3},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANACIA4\"},\"Id\":\"715L0000000ANACIA4\",\"ApexClassOrTriggerId\":\"01pL00000005aGoIAI\",\"NumLinesCovered\":51,\"NumLinesUncovered\":0},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANADIA4\"},\"Id\":\"715L0000000ANADIA4\",\"ApexClassOrTriggerId\":\"01pL00000005YLwIAM\",\"NumLinesCovered\":147,\"NumLinesUncovered\":10},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANAEIA4\"},\"Id\":\"715L0000000ANAEIA4\",\"ApexClassOrTriggerId\":\"01pa0000001pKuPAAU\",\"NumLinesCovered\":98,\"NumLinesUncovered\":1},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANAFIA4\"},\"Id\":\"715L0000000ANAFIA4\",\"ApexClassOrTriggerId\":\"01p30000000ZGdkAAG\",\"NumLinesCovered\":36,\"NumLinesUncovered\":2},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANAGIA4\"},\"Id\":\"715L0000000ANAGIA4\",\"ApexClassOrTriggerId\":\"01pL00000005ZClIAM\",\"NumLinesCovered\":31,\"NumLinesUncovered\":27},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANAHIA4\"},\"Id\":\"715L0000000ANAHIA4\",\"ApexClassOrTriggerId\":\"01pa0000001pXO3AAM\",\"NumLinesCovered\":44,\"NumLinesUncovered\":2}],\"entityTypeName\":\"ApexCodeCoverageAggregate\"}';
        J2A_ApexCodeCoverageAggregate obj = parse(json);
        System.assert(obj != null);
 
        J2A_ApexCodeCoverageAggregate.Attributes attrib = new J2A_ApexCodeCoverageAggregate.Attributes();
        J2A_ApexCodeCoverageAggregate.Records rec = new J2A_ApexCodeCoverageAggregate.Records();
 
        J2A_ApexCodeCoverageAggregate J2 = new J2A_ApexCodeCoverageAggregate();
 
        J2.done = true;
        J2.entityTypeName = 'Test';
        J2.size = 10;
        J2.totalSize = 100;
 
    }
    */
}