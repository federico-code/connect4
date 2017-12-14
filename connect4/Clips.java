package connect4;
import net.sf.clipsrules.jni.*;


public class Clips {
	private  Environment clips = null;
	private int xsize;
	private int ysize;

	
	Clips(int xsize,int ysize)
	{
		this.xsize=xsize;
		this.ysize=ysize;
		clips = new Environment();
        clips.load("c4.clp");
        clips.assertString("(dim  (x 7) (y 6))");
        System.out.println(" fatti iniziali");

        System.out.println(clips.eval("(facts)"));
        //clips.reset();
	}
	
	
	  public int decisionMaking(int userChoise,int userY,Grid my_grid){

			System.out.println("\n_______begin decision making process________\n");
		   // asserzione mossa g1
	    	String userMove = "(G1 "+userChoise+" "+userY+" )";
			clips.assertString(userMove);
			
			
			// stampa fatti wm
			System.out.println("fatti prima della mossa");
		    System.out.println(clips.eval("(facts)"));
		    System.out.println("");

		    // stampa agenda
		    System.out.println("agenda: ");
			System.out.println(clips.eval("(agenda)")); 
			
			
			// cicla finchè nclips non asserisce un next move
			int inference_step = 1;
			String pv = "()";
			while(pv.contentEquals("()"))
			{
				System.out.println("\nrunning inference engine...\n");

				clips.run(inference_step);	
				
			    pv = clips.eval("(get-all-facts-by-names next-move)").toString();
		    	System.out.println("next-move fact: "+ pv);
		    	inference_step++;
			}
			
			
	    	String clipsResponse =pv;
	    	
	    	// restituisce il numero del fatto next move 
	    	int n = getFactNumber(clipsResponse);
			System.out.println("fact:"+n);
			
			// dato il numero del fatto restituisce il numero della colonna 
			int action = Integer.valueOf((clips.eval("(fact-slot-value "+n+" move)")).toString());

			// stammpa colonna
			System.out.println("action: click col "+(action+1)+"\n");

			
			retractAllFacts("next-move");

			
			int y = my_grid.find_y(action);//check for space in collumn
			
			// asserzione mossa g2
			String computerMove = "(G2 "+action+" "+y+" )";
			clips.assertString(computerMove);	
			 
			
			System.out.println("fatti dopo mossa");
	        System.out.println(clips.eval("(facts)"));
			System.out.println("");

			System.out.println("_______end decision making process________");
			System.out.println("");
			System.out.println("");
			
			return action;  
	    }
	  
	  
	  private void insertPossibleMoveFacts(Grid my_grid, int xsize )
	    {
	    	for(int i = 0; i < xsize; i++)
	    	{
	    		int y = my_grid.find_y(i);
	    		if(y >= 0)
	    		{
	    			String computerMove = "(possible-move "+i+" "+y+" )";
	    			clips.assertString(computerMove);	
	    		}
	    	}
	    }
	  
	  private int getFactNumber(String fact)
	    {
			String a = fact.split("-")[1];
			String n = a.replace(">", "").replace(")", "");
			return Integer.valueOf(n);
	    }
	  
	  // dato il nome di un fatto ritratta tutti i fatti con quel nome  
	  private void retractAllFacts(String factName)
	    {
		    PrimitiveValue pv = (PrimitiveValue) clips.eval("(get-all-facts-by-names "+factName+")");
		    String[] possibleMoves = pv.toString().replace("(", "").replace(")", "").split(" ");
		    for(String a : possibleMoves)
		    {
		        clips.eval("(retract "+getFactNumber(a)+")");
		    }
		    
	    }

}
