/*************************************************************************
*
* PURPOSE: DAO for Show Team Assignment
*
* CLASS: ShowTeamAssignmentDao
* CREATED: 12/4/2015 Ethos Solutions - www.ethos.com
* AUTHOR: Zack Smith
***************************************************************************/
public with sharing class GC_ShowTeamAssignmentDao extends GC_BaseDao {

    private static final GC_ShowTeamAssignmentDao ShowTeamAssignmentDao = new GC_ShowTeamAssignmentDao();
    private static Set<String> relatedFields;

    private GC_ShowTeamAssignmentDao() {
        super('GC_Show_Team_Assignment__c');
        relatedFields = new Set<String> {
            'Show_Team_Member__r.Connect2_Show__c',
            'Show_Team_Member__r.User__c'
        };
        addFields(relatedFields);
    }

    public static GC_ShowTeamAssignmentDao getInstance() {
        return ShowTeamAssignmentDao;
    }

    public GC_Show_Team_Assignment__c getShowTeamAssignmentById(String staId) {
        return (GC_Show_Team_Assignment__c)getSObjectById(staId);
    }

    public List<GC_Show_Team_Assignment__c> getByShowTeamAssignmentIds(Set<String> staIds) {
        return (List<GC_Show_Team_Assignment__c>)getSObjectByIdSet('Id', staIds);
    }
}