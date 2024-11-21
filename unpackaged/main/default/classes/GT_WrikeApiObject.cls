/**
* The class contains the objects used making callouts to Wrike APIs 
*
* @author  Rahul Sinha
* @version 1.0
* @since   09-04-2019
*/

/* using inherited sharing so that the class can be called appropriately*/
public inherited sharing class GT_WrikeApiObject{
	/* the class SpaceInfoRequestObj is used for requesting info of all spaces*/
	public class SpaceInfoRequestObj{
		public boolean withArchived =false; // optional Include archived spaces, Default: false
		public boolean userIsMember; // optional Include only spaces where user is member
	}
	
	/* this class is used to store the folder and ID map in the metadata records*/
	public class FolderMapObj{
		public map<string,string> folderMap;
		
		public FolderMapObj(){
			this.folderMap= new map<string,string>();
		}
	}
	
	/*the class SpaceInfoResponseObj is used to get all spaces and can be used to get the spaceID for a customer uniquely*/
	/*public class SpaceInfoResponseObj{
		public string id; //Space ID		
		public string title; //Title
		public string avatarUrl; // Avatar URL
		public string accessType; // Access type Space Access Type, Enum: Personal, Private, Public
		public boolean archived; // Archived
	}*/
	
	/*the FolderCreateRequestObj class can be used to send a request to create either a folder or a project. For projects, the variable project needs to be initialized */
	/*public class FolderCreateRequestObj{
		public string title; //Title, cannot be empty
		public string description; //Optional	string	Folder description. If not specified, will be left blank
		public List<string> shareds; // list of contact IDs to share folder with. Folder is always shared with creator
		public ProjectSettingsObj project; //Project settings in order to create project
	}*/
	
	/* ProjectSettingsObj class is used to create a project in a folder. If this object is not null, the request will create a project instead of a folder*/
	/*public class ProjectSettingsObj{
		public List<string> ownerIds; //List of project owner IDs
		public string status; // optional Project status. Use this parameter to set status to one of these: Green, Yellow, Red, Completed, OnHold, Cancelled. 
		public string customStatusId; //optional Project custom status ID. Use this parameter if status value is not one of specified above
		public string startDate; //optional Project start date Format: yyyy-MM-dd
		public string endDate; //optional Project end date Format: yyyy-MM-dd

	}*/
	
	/* TaskDatesObj class is used to create a planned task in a project. */
	public class TaskDatesObj{		
        public TaskDatesObj(){
            this.type='Planned';
        }
        public string type{get;set;} // Values: Backlog, Milestone, Planned 
		public integer duration{get;set;} //Duration in minutes. Duration is present in Planned tasks and is optional for Backlog tasks
		public string due{get;set;} //Due date is present only in Planned and Milestone tasks Format: yyyy-MM-dd
		public string start{get;set;} //optional Project start date Format: yyyy-MM-dd
		public boolean workOnWeekends{get;set;} //optional Weekends are included in task scheduling

	}
}