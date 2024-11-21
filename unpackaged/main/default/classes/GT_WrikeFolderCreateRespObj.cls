public class GT_WrikeFolderCreateRespObj {

	public class Project {
		public String authorId;
		public List<String> ownerIds;
		public String status;
		public String startDate;
		public String endDate;
		public String createdDate;
	}

	public class CustomFields {
		public String id;
		public String value;
	}

	public String kind;
	public List<Data> data;

	public class Metadata {
		public String key;
		public String value;
	}

	public class Data {
		public String id;
		public String accountId;
		public String title;
		public String createdDate;
		public String updatedDate;
		public String description;
		public List<String> sharedIds;
		public List<String> parentIds;
		public List<String> childIds;
		public List<String> superParentIds;
		public String scope;
		public Boolean hasAttachments;
		public String permalink;
		public String workflowId;
		public List<Metadata> metadata;
		public List<CustomFields> customFields;
		public Project project;
	}

	
	public static GT_WrikeFolderCreateRespObj parse(String json) {
		return (GT_WrikeFolderCreateRespObj) System.JSON.deserialize(json, GT_WrikeFolderCreateRespObj.class);
	}
}