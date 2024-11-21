public with sharing class ManageMembersController {
      public string field1{get;set;}
      public string field2{get;set;}
      public string field3{get;set;}
      public string field4{get;set;}
      public string field5{get;set;}
      
      public string operator1{get;set;}
      public string operator2{get;set;}
      public string operator3{get;set;}
      public string operator4{get;set;}
      public string operator5{get;set;}
      
      public string value1{get;set;}
      public string value2{get;set;}
      public string value3{get;set;}
      public string value4{get;set;}
      public string value5{get;set;}
      public list<string> columns;
      public map<string,string> columnheaders;
      public list<CampaignMember> members;
      public List<list<Member>> membersw=new List<list<Member>>();
      public boolean selectall{get;set;}
      public string statusupdate{get;set;}
      public integer pagesize{get;set;}
      public integer resultsize{get;set;}
      public boolean hasnext{get;set;}
      public boolean hasprevious{get;set;}
      public integer pagenumber{get;set;}
      public boolean showcolumns{get;set;}
      public integer curentindex=0;
      public list<SelectOption> selectedcolumns{get;set;}
      Map<string,string> operatormap=new map<string,string>{'equals' => '=','not equal to' => '<>','less than' => '<','greater than' =>'>','less or equal' => '<=','greater or equal' => '>=','includes'=>'includes','excludes' => 'excludes'};
      public CampaignMember cmtoupdate{get;set;}
      public string updateoneall{get;set;}
         
      
public static Map<String, Schema.SObjectField> M =Schema.SObjectType.CampaignMember.fields.getMap();       
      Campaign camp;
    public ManageMembersController(ApexPages.standardcontroller c)
    {
        pagesize=10;
        showcolumns=false;
         camp=(Campaign)c.getrecord();
         columns=new list<string>{'status','member_owner__c','contact.name','lead.company','booth_size__c','booth_type__c'};
         columnheaders=new map<string,string>{'contact.account.owner.name'=>'Account Owner Full Name','contact.account.owner.alias'=>'Account Owner Alias','contact.account.owner.firstname'=>'Account Owner First Name','contact.account.owner.lastname'=>'Account Owner Last Name','contact.accountid'=>'Company','lead.company'=>'Company','createddate'=>'Created Date','contact.name'=>' Name','lead.name'=>'Name','contact.phone'=>'Phone','lead.Phone'=>'Phone','contact.mailingstreet'=>'Street','contact.mailingcity'=>'City','contact.mailingpostalcode'=>'Postal Code','contact.mailingcountry'=>'Country','contact.mailingstate'=>'State','lead.city'=>'City','lead.street'=>'Street','lead.postalcode'=>'Postal Code','lead.state'=>'State','lead.country'=>'Country','contact.mobilePhone'=>'Mobile','lead.MobilePhone'=>'Mobile','contact.fax'=>'Fax','lead.fax'=>'Fax','contact.owner.lastname'=>'Lead/Contact Owner Last Name','lead.owner.lastname'=>'Lead/Contact Owner Last Name','contact.owner.alias'=>'Lead/Contact Owner Alias','lead.owner.alias'=>'Lead/Contact Owner Alias','lead.owner.name'=>'Lead/Contact Full Name','contact.owner.name'=>'Lead/Contact Owner Full Name','contact.owner.firstname'=>'Lead/Contact Owner First Name','lead.owner.firstname' => 'Lead/Contact Owner First Name','lead.lastname'=>'Last Name','contact.lastname'=> 'Last Name','lead.firstname' => 'First Name','contact.FirstName' =>'First Name','contact.title'=>'Title','lead.title'=>'Title','contact.email'=>'Email','lead.email'=>'Email'};
        
                   for (string  s:M.keySet())
              columnheaders.put(s,M.get(s).getDescribe().getLabel());  
              
           Id campid=camp.id;
           string strselect='select ';
        for (string s:columnheaders.keyset())
          strselect= strselect+s+',';
          strselect=strselect.substring(0,strselect.length()-1);
         strselect+=' from CampaignMember where Campaignid=:campid ';
system.debug('strselect=================================================='+strselect);

         // members=database.query(strselect); 
         string strselect1='';
      strselect1 =  'select status,member_owner__c,contact.name,Contact.AccountId,campaignid,lead.company,booth_size__c,booth_type__c,id from CampaignMember where Campaignid=:campid';
       members=database.query(strselect1); 
    
    
         membersw=new list<list<Member>>();
         
            for (CampaignMember member :members) 
        {
               Member cl;
             List<Member> curentlist;
            if (membersw.size() >0) {curentlist=membersw[membersw.size()-1];}
            else
            {curentlist=new List<Member>();membersw.add(curentlist);}
            if (curentlist.size() <pagesize)
            {
                cl=new Member(member);
                curentlist.add(cl);
            }
            else {
                curentlist=new List<Member>();
                membersw.add(curentlist);
                 cl=new Member(member);
                curentlist.add(cl);
                }
                
                
        }
        
         
         selectedcolumns=new list<selectoption>();
         for (string s:columns)
         if (columnheaders.get(s) != null)
         {
            system.debug(s);
          selectedcolumns.add(new selectoption(s,columnheaders.get(s)));
         }
         members= new list<CampaignMember>();
    }

    public pagereference savecolumns()
    {
        columns.clear();
        
        for(selectoption s:selectedcolumns)
          columns.add(s.getvalue());
          showcolumns=false; 
          go();
        return null;
    }
    public pagereference cancelcolumns()
    {
        showcolumns=false; 
        return null;
    }
        public List<Member> getmemberswcurent()
    {
           if (membersw!= null && curentindex > -1 && curentindex < membersw.size())
            return membersw[curentindex];
        return null;
    }
    public pagereference showcolumns()
    {
        showcolumns=!showcolumns; 
        return null;
    }   
    
    public List<SelectOption> getfields()
    {
        return getfields(true);
    }
    public List<SelectOption> getfields2()
    {
        return getfields(false);
    }   
       public List<SelectOption> getfields(boolean notshowcolumns)
    {
      List<SelectOption> options=new List<SelectOption>();
       
       options.add(new SelectOption('none','--None--'));         
       List<String> fieldlist=new List<String>();
       for (string  s:M.keySet())
        {
            if (M.get(s).getDescribe().getType() != Schema.DisplayType.textarea)            fieldlist.add(s);
        }
        fieldlist.add('contact.owner.alias');   
        fieldlist.add('contact.owner.firstname');
        fieldlist.add('contact.owner.lastname');
        fieldlist.add('contact.owner.name');
        fieldlist.add('contact.phone');
        fieldlist.add('contact.email');
        fieldlist.add('contact.mobilePhone');
        fieldlist.add('contact.fax');
        fieldlist.add('lead.city');
        fieldlist.add('lead.street');
        fieldlist.add('lead.state');
        fieldlist.add('lead.country');
        fieldlist.add('lead.postalcode');
        fieldlist.add('lead.firstname');
        fieldlist.add('lead.lastname');
        fieldlist.add('lead.title');
        
        fieldlist.add('contact.account.owner.name');
         fieldlist.add('contact.account.owner.alias');
          fieldlist.add('contact.account.owner.firstname');
           fieldlist.add('contact.account.owner.lastname');
        
        fieldlist.sort();
        set<string>columnsset=new set<string>();
        columnsset.addall(columns);
        for (string s:fieldlist) 
        if ((columnsset.contains(s) == false && notshowcolumns) || notshowcolumns ==false)
        { 

            if (M.containsKey(s) == false)
            options.add(new SelectOption(s,columnheaders.get(s)));
            else
            options.add(new SelectOption(s,M.get(s).getDescribe().getLabel()));
        }
            
     
        return options;
    }
   public pagereference first(){curentindex=0;return null;}
    public pagereference last(){curentindex=membersw.size() -1;return null;}
   public pagereference next()
    {
        if (membersw != null )
        if (curentindex < membersw.size() -1){ curentindex++; }
        return null;
    }
  
    public pagereference previos()
    {
        if (curentindex >=1) curentindex--;
        return null;
    }
    public List<SelectOption> getstatuses()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       list<CampaignMemberStatus> statuses=  [SELECT c.Label, c.CampaignId FROM CampaignMemberStatus c WHERE c.CampaignId =:camp.id];
      options.add(new SelectOption('','Update Status'));      
       for( CampaignMemberStatus f: statuses)
       {
          options.add(new SelectOption(f.label, f.label));
       }       
       return options;
    }
    public pagereference changestatus()
    {
        if (statusupdate <> null)
        if (selectall)
        {
            for (integer i=0;i<membersw.size();i++)
            for (Member mm:membersw[i])
               mm.member.status=statusupdate;
        }
        else
           for (integer i=0;i<membersw.size();i++)
            for (Member mm:membersw[i])
         if (mm.isselected) mm.member.status=statusupdate;
         update members;
         return null;
    }
    public string applyfilters(string field,string operator,string value,string strselect)
    {
           if (field <> null && operator <> null)
           if (operatormap.containskey(operator))
           {
            if (value == '')
            {
                
             strselect+=' AND ('+field+ ' '+operatormap.get(operator)+' \''+value+'\'';
             String colname=columnheaders.get(field);
             for (string s:columnheaders.keyset())
                if (columnheaders.get(s) == colname && s<> field)
                 strselect+=' OR '+s+ ' '+operatormap.get(operator)+' \''+value+'\'';
                 strselect+=')';
            }
            else
            {
                string strvalue=' \''+value+'\')';
                 if (M.get(field).getDescribe().getType() == Schema.DisplayType.double) 
                    strvalue=' '+value+')';
             strselect+=' AND (('+field+'<>null AND '+field+ ' '+operatormap.get(operator)+strvalue;
             String colname=columnheaders.get(field);
             for (string s:columnheaders.keyset())
                if (columnheaders.get(s) == colname && s<> field)
                 strselect+=' OR( '+s+'<> null AND '+s+ ' '+operatormap.get(operator)+strvalue;
                 strselect+=')'; 
            }
           }
           else
           if (operator == 'contains')
           {
            String colname=columnheaders.get(field);
             strselect+=' AND ('+field+ ' Like \'%'+value+'%\'';
             for (string s:columnheaders.keyset())
                if (columnheaders.get(s) == colname && s<> field)
                 strselect+=' Or '+s+ ' Like \'%'+value+'%\'';
                 strselect+=')';
             
           }
             else
            if (operator == 'starts with')
            {
                String colname=columnheaders.get(field);
                strselect+=' AND ('+field+ ' Like \''+value+'%\'';
                for (string s:columnheaders.keyset())
                    if (columnheaders.get(s) == colname && s<> field)
                        strselect+=' OR '+s+ ' Like \''+value+'%\'';
                strselect+=')';          
            }
            else
           if (operator == 'does not contain')
           {
             String colname=columnheaders.get(field);
             strselect+=' AND (('+field+'<> null AND'+ '( NOT '+field+ ' Like \'%'+value+'%\'))';
             for (string s:columnheaders.keyset())
                if (columnheaders.get(s) == colname && s<> field)
                 strselect+=' OR(('+s+'<> null AND '+' (NOT '+s+ ' Like \'%'+value+'%\')))';
                 strselect+=')';             
           }
           return strselect;
    }
    public pagereference go()
    {
        id campid=camp.id;
        string strselect='select ';
        for (string s:columnheaders.keyset())
          strselect= strselect+s+',';
          strselect=strselect.substring(0,strselect.length()-1);
         strselect+=' from CampaignMember where Campaignid=:campid ';
        
        strselect=applyfilters(field1,operator1,value1,strselect);
        strselect=applyfilters(field2,operator2,value2,strselect);
        strselect=applyfilters(field3,operator3,value3,strselect);
        strselect=applyfilters(field4,operator4,value4,strselect);
        strselect=applyfilters(field5,operator5,value5,strselect);
 
       try 
       {
        members=database.query(strselect);
       }
       catch(exception e){}
        membersw.clear();
        membersw=new list<list<Member>>();
        for (CampaignMember member :members) 
        {
             Member cl;
             List<Member> curentlist;
            if (membersw.size() >0) {curentlist=membersw[membersw.size()-1];}
            else
            {curentlist=new List<Member>();membersw.add(curentlist);}
            if (curentlist.size() <pagesize)
            {
                cl=new Member(member);
                curentlist.add(cl);
            }
            else {
                curentlist=new List<Member>();
                membersw.add(curentlist);
                 cl=new Member(member);
                curentlist.add(cl);
                }
        }    
        members= new list<CampaignMember>();    
        return null;
    }
    public pagereference remove()
    {
        if (selectall)
        {
          delete members;
          go();
        }
        else
        {
            list<CampaignMember> ltodel=new list<CampaignMember>();
            for (integer j=0;j<membersw.size();j++)
            for (Member i:membersw[j])
             if (i.isselected) ltodel.add(i.member);
             delete ltodel;
             go();
        }
          
        return null;
    }
    public pagereference selectallLines()
    {
        if (selectall)
        for (integer i=0;i<membersw.size();i++)
        for (Member mm:membersw[i])
          mm.isselected=true;
        else
        for (integer i=0;i<membersw.size();i++)
            for (Member mm:membersw[i])
          mm.isselected=false;
          return null;
    }
    public pagereference removeoneline()
    {
        /*
        CampaignMember ctodel;
        id mid=System.currentPageReference().getParameters().get('mid');
        for (Member me:membersw)
           if (me.member.id == mid) {ctodel=me;break;}
           delete ctodel;
           go();*/
        return null;
    }
    public integer getcurin()   {    return curentindex+1;}
    public pagereference recalculatelines()
    {
        List<list<Member>> clineslistnew=new List<list<Member>>();
        
        for (integer i=0;i<membersw.size();i++)
            for (Member cl :membersw[i]) 
        {
            
             integer linenumber;
             List<Member> curentlist;
            if (clineslistnew.size() >0) {curentlist=clineslistnew[clineslistnew.size()-1];}
            else
            {curentlist=new List<Member>();clineslistnew.add(curentlist);}
            if (curentlist.size() <pagesize)
            {
                curentlist.add(cl);
            }
            else {
                curentlist=new List<Member>();
                clineslistnew.add(curentlist);
                curentlist.add(cl);
                }
        }
        membersw=clineslistnew;
        return null;
    }
    public integer getnoofrecords()
    {
        integer total=0;
        for (integer i=0;i<membersw.size();i++)
          total+=membersw[i].size();
        return total;
    }
    public Integer getlistsize()
    {
        if (membersw != null)
        return membersw.size();
        return 0;
    }
    public pagereference clearfilters()
    {
        field1=null;
        value1=null;
        operator1=null;
        
        field2=null;
        value2=null;
        operator2=null;
        
        field3=null;
        value3=null;
        operator3=null;
        
        field4=null;
        value4=null;
        operator4=null;
        
        field5=null;
        value5=null;
        operator5=null;
        
        return null;
    }
    public pagereference save()
    {
        update members;
        return null;
    }
    public pagereference copyvalueandsave()
    {
        list<CampaignMember > listtoupdate=new list<CampaignMember>();
        string mownervalue;
        for (integer i=0;i<membersw.size();i++)
         for (member mm:membersw[i])
         {
           if (mm.isselected) listtoupdate.add(mm.member);
           if (mm.showinput){ mownervalue=mm.member.member_owner__c;mm.showinput=false;}
           
         }
         
         if (mownervalue <> null)
           for (CampaignMember mm:listtoupdate)
              mm.member_owner__c= mownervalue;
              
            update listtoupdate;   
            go();
           
        return null;
    }
    
    public Component.Apex.PageBlockTable getMyPageBlockTable()
{
    Component.Apex.PageBlockTable table = new Component.Apex.PageBlockTable(var='m');
    table.expressions.value='{!memberswcurent}';
    table.id='tableid';
    
    Component.Apex.Column columnh = new Component.Apex.Column(headerValue='');
    Component.Apex.inputcheckbox inpcall = new Component.Apex.inputcheckbox();
    inpcall.expressions.value='{!selectall}';
    columnh.facets.header=inpcall;
     
     Component.Apex.actionsupport actionsupporta = new Component.Apex.actionsupport();
            actionsupporta.event='onchange';
            actionsupporta.rerender=new set<string>{'tableid'};
            actionsupporta.expressions.action='{!selectallLines}';
            inpcall.childComponents.add(actionsupporta); 
    
    Component.Apex.inputcheckbox inpc = new Component.Apex.inputcheckbox();
    inpc.expressions.value='{!m.isselected}';
    inpc.id='selectcol';
    columnh.childComponents.add(inpc);
    table.childComponents.add(columnh);
     
    Component.Apex.Column actionColumn = new Component.Apex.Column(headerValue='Action');
    actioncolumn.styleClass='actionColumn';
    table.childComponents.add(actioncolumn);
    Component.Apex.commandlink editl = new Component.Apex.commandlink();
    editl.expressions.action='{!m.edit}';
    editl.value='Edit ';
    editl.styleclass='actionLink';
     actioncolumn.childComponents.add(editl);
 /*
     Component.Apex.commandlink reml = new Component.Apex.commandlink();
    reml.expressions.action='{!m.remove}';
    reml.value='| Remove';
    reml.styleclass='actionLink';
    reml.rerender=new set<string>{'tableid'};
     actioncolumn.childComponents.add(reml);
     */
 
     
    
    for(string s:columns)
    {
        Component.Apex.OutputField outputField = new Component.Apex.OutputField();
        outputField.expressions.value = '{!m.member.' + s + '}';
             
        Component.Apex.Column column = new Component.Apex.Column(headerValue=columnheaders.get(s));
        column.childComponents.add(outputField);
         for (string ss:columnheaders.keyset())
           if (columnheaders.get(ss) == columnheaders.get(s) && ss <> s)
                {
                 Component.Apex.OutputField outputFieldv = new Component.Apex.OutputField();
                 outputFieldv.expressions.value = '{!m.member.' + ss + '}';
                 column.childComponents.add(outputFieldv);
                }
        table.childComponents.add(column);
        
        if (s == 'Member_Owner__c')
        {
            Component.Apex.actionsupport actionsupport = new Component.Apex.actionsupport();
            actionsupport.event='ondblclick';
            actionsupport.rerender=new set<string>{'tableid'};
            actionsupport.expressions.action='{!m.changeshowin}';
            
            Component.Apex.Inputfield inputfield = new Component.Apex.Inputfield();
            inputfield.expressions.value = '{!m.member.' + s + '}';
            inputfield.expressions.rendered='{!m.showinput}';
            outputfield.expressions.rendered='{!NOT(m.showinput)}';
            inputfield.id='inpid';
            column.childComponents.add(inputfield);
            column.childComponents.add(actionsupport);
            
            Component.Apex.actionsupport actionsupport1 = new Component.Apex.actionsupport();
            actionsupport1.event='onchange';
            actionsupport1.onsubmit='if(checkmultiselection()) { saveall(); }';
            actionsupport1.rerender=new set<string>{'tableid'};
            actionsupport1.expressions.action='{!m.changeandupdate}';
            inputfield.childComponents.add(actionsupport1);
        
            
        }
    }
    return table;
}

public  class Member
{
    public  CampaignMember member{get;set;}
    public  boolean showinput{get;set;}
    public boolean isselected{get;set;}
    public Member(CampaignMember mm){member=mm;showinput=false;isselected=false;}
    
    public pagereference changeshowin()
    {
        showinput=!showinput;
        return null;
    }
    public pagereference changeandupdate()
    {
        showinput=!showinput;
        update member;
        return null;
    }   
    public pagereference edit()
    {
         ApexPages.standardController c=new ApexPages.Standardcontroller(member);
        Pagereference p=c.edit();
        p.getParameters().put('retUrl','/apex/ManageMembers?id='+member.campaignid); 
        return p;
      return null;  
    }
    public pagereference remove()
    {
        delete member;
        return null;
    }
    
}

}