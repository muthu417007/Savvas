global class CPQValidator_cls{

    private static boolean blnAlreadyDone = false;
    
    public static boolean hasAlreadyDone(){ 
        return blnAlreadyDone;
    }
 
 
 
        public static void setAlreadyDone() {       
            blnAlreadyDone = true;
    }
}