package sunset;

import com.yworks.yfiles.geometry.PointD;
import com.yworks.yfiles.geometry.RectD;
import com.yworks.yfiles.graph.IBend;
import com.yworks.yfiles.graph.IEdge;
import com.yworks.yfiles.graph.IGraph;
import com.yworks.yfiles.graph.ILabel;
import com.yworks.yfiles.graph.INode;
import com.yworks.yfiles.graph.IPort;
import com.yworks.yfiles.graph.LayoutUtilities;
import com.yworks.yfiles.graph.portlocationmodels.FreeNodePortLocationModel;
import com.yworks.yfiles.graph.styles.ShapeNodeShape;
import com.yworks.yfiles.graph.styles.ShapeNodeStyle;
import com.yworks.yfiles.graphml.GraphMLIOHandler;
import com.yworks.yfiles.layout.hierarchic.HierarchicLayout;
import com.yworks.yfiles.view.Colors;
import com.yworks.yfiles.view.GraphComponent;
import com.yworks.yfiles.view.Pen;
import com.yworks.yfiles.view.input.CommandAction;
import com.yworks.yfiles.view.input.GraphEditorInputMode;
import com.yworks.yfiles.view.input.ICommand;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.io.IOException;
import java.time.Duration;

import javax.swing.AbstractAction;
import javax.swing.JFrame;
import javax.swing.JToolBar;
import javax.swing.WindowConstants;  
import javax.swing.SwingUtilities;

public class openGUI {


	public openGUI() {
		// create a component for displaying and editing a graph. 
		// need to import com.yworks.yfiles.view.GraphComponent;
		GraphComponent graphComponent = new GraphComponent();
		
		// Enabling default user interaction features, always follow Graphcomponent
		graphComponent.setInputMode(new GraphEditorInputMode());
		
	    // enable loading and saving
	    graphComponent.setFileIOEnabled(true);
		
		// get the graph of a GraphComponent after initialization one
		// need to import com.yworks.yfiles.graph.IGraph;
		IGraph graph = graphComponent.getGraph();
		
	    // create a toolbar
	    JToolBar toolbar = new JToolBar();
	    toolbar.add(new LayoutAction(graphComponent));
	    // add buttons for open and save to the toolbar
	    toolbar.add(new CommandAction(ICommand.OPEN, null, graphComponent));
	    toolbar.add(new CommandAction(ICommand.SAVE, null, graphComponent));
	    
		// create a top-level window and add the graph component
	    JFrame frame = new JFrame("openGUI");
	    frame.setSize(500, 500);
	    frame.setLocationRelativeTo(null);
	    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
	    frame.add(graphComponent, BorderLayout.CENTER);
	    // add Toolbar
	    frame.add(toolbar, BorderLayout.NORTH);
	    //Need import java.awt.BorderLayout;
	    frame.setVisible(true);
	    
	    // Fitting the graph in the visible area
	    graphComponent.fitGraphBounds();
	    
	    //
	    GraphMLIOHandler graphMLIOHandler = new GraphMLIOHandler();

	    // configure the handler to your needs ...

	    // set the custom GraphMLIOHandler on GraphComponent
	    graphComponent.setGraphMLIOHandler(graphMLIOHandler);
	    
	    try {
			graphMLIOHandler.read(graph, "G:\\Vis_SubHierarchie\\onto_local\\test\\equivalent_Test_4.graphml");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    
	}

	public static void main(String[] args) {
	    SwingUtilities.invokeLater(openGUI::new);
	}
	
	private static class LayoutAction extends AbstractAction {
		  private GraphComponent graphComponent;

		  LayoutAction(GraphComponent graphComponent) {
		    super("Hierarchy Layout");
		    this.graphComponent = graphComponent;
		  }

		  @Override
		  public void actionPerformed(ActionEvent e) {
		    // disable the action/button once the layout starts
		    setEnabled(true);

		    HierarchicLayout layout = new HierarchicLayout();

		    LayoutUtilities.morphLayout(graphComponent, layout, Duration.ofMillis(500),
		        // re-enable the action/button after everything has finished
		        (source, args) -> setEnabled(true));
		  }
	}	
}
