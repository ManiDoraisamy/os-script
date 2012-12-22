package com.orangescape.script.entity;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.jdo.JDOHelper;
import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;
import javax.jdo.Query;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserServiceFactory;

public class DataAccess
{
    public static final PersistenceManagerFactory pmfInstance =
        JDOHelper.getPersistenceManagerFactory("transactions-optional");
	
    private PersistenceManager pm;
    private User user;
    
    public DataAccess()
    {
    	pm = pmfInstance.getPersistenceManager();
    	user = UserServiceFactory.getUserService().getCurrentUser();
    }
    
    public List<Script> listScripts()
    {
    	Query query = pm.newQuery(Script.class, "author == :author && active == :active");
        return (List<Script>)query.execute(user.getEmail(), Boolean.TRUE);
    }
    
    public Script create()
    {
    	Script script = new Script("UntitledScript", user.getEmail());
    	return pm.makePersistent(script);
    }
    
    public Script get(String key)
    {
    	return pm.getObjectById(Script.class, key);
    }
    
    public void close()
    {
    	pm.close();
    }
    
    public void finalize()
    {
    	if(!pm.isClosed())
    	{
    		System.err.println("Found at GC: PersistenceManager not closed. Check is you closed all DataAccess in the code.");
    		pm.close();
    	}
    }
}
