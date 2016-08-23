/**
 * 
 */
package com.thinkbiganalytics.metadata.modeshape.security.action;

import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.security.Privilege;

import org.modeshape.jcr.security.SimplePrincipal;

import com.thinkbiganalytics.metadata.modeshape.JcrMetadataAccess;
import com.thinkbiganalytics.metadata.modeshape.MetadataRepositoryException;
import com.thinkbiganalytics.metadata.modeshape.common.SecurityPaths;
import com.thinkbiganalytics.metadata.modeshape.security.JcrAccessControlUtil;
import com.thinkbiganalytics.metadata.modeshape.support.JcrUtil;
import com.thinkbiganalytics.security.UserRolePrincipal;
import com.thinkbiganalytics.security.UsernamePrincipal;
import com.thinkbiganalytics.security.action.AllowedActions;
import com.thinkbiganalytics.security.action.config.ActionsTreeBuilder;
import com.thinkbiganalytics.security.action.config.ModuleActionsBuilder;

/**
 *
 * @author Sean Felten
 */
public class JcrModuleActionsBuilder extends JcrAbstractActionsBuilder implements ModuleActionsBuilder {
    
    public static final String ALLOWED_ACTIONS = "tba:allowedActions";
    
    private final String protoModulesPath;
    private Node groupsNode;
    private Node protoActionsNode;
    private Node actionsNode;
    
    
    public JcrModuleActionsBuilder(String protoPath) {
        this.protoModulesPath = protoPath;
    }
    
    public JcrModuleActionsBuilder(Node groupsNode) {
        this((String) null);
        this.groupsNode = groupsNode;
    }

    /* (non-Javadoc)
     * @see com.thinkbiganalytics.security.action.config.ModuleActionsBuilder#group(java.lang.String)
     */
    @Override
    public ActionsTreeBuilder<ModuleActionsBuilder> group(String name) {
        Session session = JcrMetadataAccess.getActiveSession();
        
        try {
            Node securityNode = session.getRootNode().getNode(SecurityPaths.SECURITY.toString());
            this.groupsNode = this.groupsNode == null ? session.getRootNode().getNode(this.protoModulesPath) : this.groupsNode;
            this.protoActionsNode = JcrUtil.getOrCreateNode(groupsNode, name, ALLOWED_ACTIONS);
            this.actionsNode = JcrUtil.getOrCreateNode(securityNode, name, ALLOWED_ACTIONS);
            
            return new JcrActionTreeBuilder<>(protoActionsNode, this);
        } catch (RepositoryException e) {
            throw new MetadataRepositoryException("Failed to access root node for allowable actions", e);
        }
    }

    /* (non-Javadoc)
     * @see com.thinkbiganalytics.security.action.config.ModuleActionsBuilder#build()
     */
    @Override
    public AllowedActions build() {
        try {
            Session session = this.protoActionsNode.getSession();
            
            JcrAccessControlUtil.addPermissions(this.protoActionsNode, this.managementPrincipal, Privilege.JCR_ALL);
            JcrAccessControlUtil.addPermissions(this.protoActionsNode, new UsernamePrincipal(session.getUserID()), Privilege.JCR_ALL);
            JcrAccessControlUtil.addPermissions(this.protoActionsNode, SimplePrincipal.EVERYONE, Privilege.JCR_READ);
            
            JcrAllowedActions protoAllowed = new JcrAllowedActions(this.protoActionsNode);
            JcrAllowedActions allowed = protoAllowed.copy(this.actionsNode, protoAllowed, this.managementPrincipal, Privilege.JCR_ALL);
            
            JcrAccessControlUtil.addPermissions(this.actionsNode, this.managementPrincipal, Privilege.JCR_ALL);
            JcrAccessControlUtil.addPermissions(this.actionsNode, SimplePrincipal.EVERYONE, Privilege.JCR_READ);
            
            for (Node action : JcrUtil.getNodesOfType(this.actionsNode, JcrAllowableAction.ALLOWABLE_ACTION)) {
                // Initially only allow the mgmt principal access to the actions themselves
                JcrAccessControlUtil.addPermissions(action, this.managementPrincipal, Privilege.JCR_ALL);
            }
            
            return protoAllowed;
        } catch (RepositoryException e) {
            throw new MetadataRepositoryException("Failed to build action", e);
        }
    }

}