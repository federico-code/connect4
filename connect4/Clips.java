package connect4;
import net.sf.clipsrules.jni.*;


public class Clips {
	private  Environment clips = null;
	private int xsize;
	private int ysize;
	private int cpu_turn = 2;
	private int player_turn = 1;
	
	Clips(int xsize,int ysize)
	{
		this.xsize=xsize;
		this.ysize=ysize;
		clips = new Environment();
		clips.load("connect.clp");
		clips.load("defense1.clp");
		clips.load("attack1.clp");
        String dim_assert = "(dim  (x "+ (xsize-1) +") (y "+(ysize-1)+"))";
        System.out.println(dim_assert);
        String cpu_turn_assert = "(cpu_turn "+ cpu_turn + ")";
        String player_turn_assert = "(player_turn "+ player_turn + ")";
        clips.assertString(dim_assert);
        clips.assertString(cpu_turn_assert);
        clips.assertString(player_turn_assert);

        System.out.println("fatti iniziali");

        System.out.println(clips.eval("(facts)"));
        //clips.reset();
	}
	
	
	  public int decisionMaking(int userChoise,int userY,Grid my_grid){

		  Thread t = Thread.currentThread();
	    	try {
				t.sleep(500);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println("\n_______begin decision making process________\n");

		    
	    	String userMove = "(G "+player_turn+" "+userChoise+" "+userY+" )";
			clips.assertString(userMove);	
			
			
			insertPossibleMoveFacts( my_grid,  xsize );
			
			
			int inference_step = 1;
			String pv = "()";
			while(pv.contentEquals("()"))
			{
				System.out.println("\n########running inference engine ("+inference_step+")...##########\n");
				
		        System.out.println("fatti prima della mossa");
		        System.out.println(clips.eval("(facts)"));
				System.out.println("");
				
				System.out.println("agenda: ");
				System.out.println(clips.eval("(agenda)"));
				
				clips.run(1);	
				
			    pv = clips.eval("(get-all-facts-by-names next-move)").toString();
		    	System.out.println("next-move fact: "+ pv);
		    	inference_step++;
				System.out.println("\n########end inference engine...##########\n");

			}

	    	String clipsResponse = pv;
	    	
			int n = getFactNumber(clipsResponse);
			System.out.println("fact:"+n);

			int action = Integer.valueOf((clips.eval("(fact-slot-value "+n+" move)")).toString());
	    	
			System.out.println("action: click col "+(action+1)+"\n");
			
			retractAllFacts("possible-move");
			retractAllFacts("next-move");
			
			int y = my_grid.find_y(action);
			String computerMove = "(G "+cpu_turn+" "+action+" "+y+" )";
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
