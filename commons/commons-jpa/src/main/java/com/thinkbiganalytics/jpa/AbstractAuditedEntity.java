/**
 * 
 */
package com.thinkbiganalytics.jpa;

/*-
 * #%L
 * thinkbig-commons-jpa
 * %%
 * Copyright (C) 2017 ThinkBig Analytics
 * %%
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * #L%
 */

import org.hibernate.annotations.Type;
import org.joda.time.DateTime;

import javax.persistence.Column;
import javax.persistence.EntityListeners;
import javax.persistence.MappedSuperclass;

/**
 * Base type for entities that have standard timestamp auditing columns in their tables.
 * @author Sean Felten
 */
@MappedSuperclass
@EntityListeners(AuditTimestampListener.class)
public class AbstractAuditedEntity implements AuditedEntity {
    
    @Type(type="org.jadira.usertype.dateandtime.joda.PersistentDateTime")
    @Column(name="created_time")
    private DateTime createdTime;
    
    @Type(type="org.jadira.usertype.dateandtime.joda.PersistentDateTime")
    @Column(name="modified_time")
    private DateTime modifiedTime;

    /* (non-Javadoc)
     * @see com.thinkbiganalytics.jpa.AuditedEntity#setCreatedTime(org.joda.time.DateTime)
     */
    @Override
    public void setCreatedTime(DateTime time) {
        this.createdTime = time;
    }

    /* (non-Javadoc)
     * @see com.thinkbiganalytics.jpa.AuditedEntity#setModifiedTime(org.joda.time.DateTime)
     */
    @Override
    public void setModifiedTime(DateTime time) {
        this.modifiedTime = time;
    }
    
    public DateTime getCreatedTime() {
        return createdTime;
    }
    
    public DateTime getModifiedTime() {
        return modifiedTime;
    }

}
