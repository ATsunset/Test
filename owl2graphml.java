package sunset;

import java.io.FileNotFoundException;  
import java.io.FileOutputStream;  
  
import javax.xml.transform.Transformer;  
import javax.xml.transform.TransformerConfigurationException;  
import javax.xml.transform.TransformerException;  
import javax.xml.transform.TransformerFactory;  
import javax.xml.transform.stream.StreamResult;  
import javax.xml.transform.stream.StreamSource;  

public class owl2graphml {
    public static void transformXmlByXslt(String srcXml, String dstXml, String xslt) {  
        
        // 获取转换器工厂  TransformerFactory
        TransformerFactory tf = TransformerFactory.newInstance();  
          
        try {  
            // 获取转换器对象实例  
            Transformer transformer = tf.newTransformer(new StreamSource(xslt));  
            // 进行转换  
            transformer.transform(new StreamSource(srcXml),  
                    new StreamResult(new FileOutputStream(dstXml)));  
        } catch (TransformerConfigurationException e) {  
            e.printStackTrace();  
        } catch (FileNotFoundException e) {  
            e.printStackTrace();  
        } catch (TransformerException e) {  
            e.printStackTrace();  
        }  
    }  
      
      
    public static void main(String[] args) {  
        String srcXml = "G:\\Vis_SubHierarchie\\onto_local\\pizza.owl_original.xml";  
        //String dstXml = "src/pizza.xml";
        String dstXml = "G:\\Vis_SubHierarchie\\onto_local\\test\\equivalent_Test_4.graphml";
        String xslt = "D:\\java\\java_project\\sunset\\src\\main\\java\\sunset\\equivalent_test4.xsl";  
          
        transformXmlByXslt(srcXml, dstXml, xslt);  
    }  
}
