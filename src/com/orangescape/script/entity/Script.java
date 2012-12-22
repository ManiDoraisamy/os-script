package com.orangescape.script.entity;

import java.util.Date;

import javax.jdo.annotations.Extension;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.orangescape.script.execution.Language;
import com.google.appengine.api.datastore.Text;

@PersistenceCapable
public class Script {
	
    @PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    @Extension(vendorName="datanucleus", key="gae.encoded-pk", value="true")
    public String key;
    
    @Persistent
    public String name;
    @Persistent
    public String language;
    @Persistent
    public Text code;
    @Persistent
    public String inputTypes;
    @Persistent
    public String outputTypes;
    @Persistent
    public String inputData;
    @Persistent
    public String author;
    @Persistent
    public Date createdat;
    @Persistent
    public Date lastmodified;
    @Persistent
    public Boolean active;
    
    public Script(){}
    
    public Script(String name, String author)
    {
    	this.name = name;
    	this.language = Language.languages.get(0);
    	this.author = author;
    	this.createdat = new Date();
    	this.active = true;
    }
    
    public void update(String name, String language, String code)
    {
    	this.name = name;
    	this.language = language;
    	this.code = new Text(code);
        this.lastmodified = new Date();
    }
    
    public void updateMetaData(String inputTypes, String outputTypes, String inputData)
    {
    	this.inputTypes = inputTypes;
    	this.outputTypes = outputTypes;
    	this.inputData = inputData;
    }
    
    public void setCode(String code)
    {
    	this.code = new Text(code);
    }
    
    public String getCode()
    {
    	return this.code.getValue();
    }
}
