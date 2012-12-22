package com.orangescape.script.entity;

import java.util.Date;
import java.util.List;

import javax.jdo.annotations.Extension;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Text;

@PersistenceCapable(identityType = IdentityType.APPLICATION) 
public class Library {
	
    @PrimaryKey
    public String name;
    
    @Persistent
    public String description;
    @Persistent
    public String language;
    @Persistent
    public Text code;
    @Persistent
    public List<String> tags;
    @Persistent
    public String author;
    @Persistent
    public Date createdat;
    @Persistent
    public Date lastmodified;
    @Persistent
    public Boolean active;
    
    public Library(){}
    
    public Library(String name, String author)
    {
    	this.name = name;
    	this.author = author;
    	this.createdat = new Date();
    }
    
    public Library description(String desc)
    {
    	this.description = desc; 
    	lastmodified = new Date(); 
    	return this;
    }
    
    public Library code(String code)
    {
    	this.code = new Text(code); 
    	lastmodified = new Date(); 
    	return this;
    }
    
    public Library active(boolean active)
    {
    	this.active = active; 
    	lastmodified = new Date(); 
    	return this;
    }
}