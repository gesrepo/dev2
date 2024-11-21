public with sharing class CustomUserObject {
	
	public Id Id {get; set;}
	public String FirstName {get; set; }
	public String LastName {get; set; }
	public String Email {get; set; }
	public Boolean IsChecked {get; set; }
	public Integer Count {get; set; }
	
	public CustomUserObject()
	{
		
	}
	
	public CustomUserObject(User usr)
	{
		this.Id = usr.Id;
		this.FirstName = usr.FirstName;
		this.LastName = usr.LastName;
		this.Email = usr.Email;	
	}	
	
	public CustomUserObject(Id id, String firstName, String lastName, String email, Boolean isChecked, Integer count)
	{
		this.Id = id;
		this.FirstName = firstName;
		this.LastName = lastName;
		this.Email = email;
		this.IsChecked = ischecked;
		this.Count = count;
	}	

}