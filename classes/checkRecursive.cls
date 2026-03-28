// Class that prevents trigger from recursively called
public Class checkRecursive{
    private static boolean run = true;
    public static boolean inFutureContext = false;
    
    public static boolean runOnce(){
    	if(run){
     		run=false;
     		return true;
    	}else{
        	return run;
    	}
    }
}