/**
* The class contains the objects used making callouts to Wrike APIs 
*
* @author  Rahul Sinha
* @version 1.0
* @since   09-04-2019
*/

public class GT_WrikeFolderSearchRespObj {

	public class Project {
		public String authorId;
		public List<String> ownerIds;
		public String status;
		public String startDate;
		public String endDate;
		public String createdDate;
	}

	public class Data {
		public String id;
		public String title;
		public List<String> children;
		public List<String> childIds;
		public String scope;
		public Project project;
	}

	public class Children {
	}

	public String kind;
	public List<Data> data;

	
	public static GT_WrikeFolderSearchRespObj parse(String json) {
		return (GT_WrikeFolderSearchRespObj) System.JSON.deserialize(json, GT_WrikeFolderSearchRespObj.class);
	}
}