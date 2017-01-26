package com.thinkbiganalytics.discovery.model;

/*-
 * #%L
 * thinkbig-schema-discovery-model2
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

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.thinkbiganalytics.discovery.schema.DataTypeDescriptor;
import com.thinkbiganalytics.discovery.schema.Field;

import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.List;
import java.util.Vector;

@JsonIgnoreProperties(ignoreUnknown = true)
public class DefaultField implements Field {

    private String name;

    private String description = "";

    private String nativeDataType;

    private String derivedDataType;

    private boolean primaryKey = false;

    private boolean nullable = true;

    private boolean modifiable = true;

    @JsonDeserialize(as = DefaultDataTypeDescriptor.class)
    private DataTypeDescriptor dataTypeDescriptor;

    public List<String> sampleValues = new Vector<>();

    private boolean updatedTracker;

    private String precisionScale;

    private boolean createdTracker;


    public void setNativeDataType(String nativeDataType) {
        this.nativeDataType = nativeDataType;
    }

    public String getDerivedDataType() {
        return derivedDataType;
    }


    @Override
    public Boolean isPrimaryKey() {
        return primaryKey;
    }

    @Override
    public Boolean isNullable() {
        return nullable;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = (this.description == null ? "" : description);
    }

    public Boolean getPrimaryKey() {
        return primaryKey;
    }

    public void setPrimaryKey(Boolean primaryKey) {
        this.primaryKey = (primaryKey == null ? false : primaryKey);
    }

    public Boolean getNullable() {
        return nullable;
    }

    public void setNullable(Boolean nullable) {
        this.nullable = (nullable == null ? true : nullable);
    }

    public List<String> getSampleValues() {
        return sampleValues;
    }

    public void setSampleValues(List<String> sampleValues) {
        this.sampleValues = sampleValues;
    }

    @Override
    public void setDerivedDataType(String type) {
        this.derivedDataType = type;
    }

    @Override
    public String getNativeDataType() {
        return this.nativeDataType;
    }

    @Override
    public Boolean isModifiable() {
        return this.modifiable;
    }

    @Override
    public void setModifiable(Boolean isModifiable) {
        this.modifiable = isModifiable;
    }

    @Override
    public DataTypeDescriptor getDataTypeDescriptor() {
        return dataTypeDescriptor;
    }

    @Override
    public void setDataTypeDescriptor(DataTypeDescriptor dataTypeDescriptor) {
        this.dataTypeDescriptor = dataTypeDescriptor;
    }

    /**
     * Returns the structure in the format: Name | DataType | Desc | Primary \ CreatedTracker | UpdatedTracker
     */
    public String asFieldStructure() {
        return name + "|" + getDataTypeWithPrecisionAndScale() + "|" + description + "|" + BooleanUtils.toInteger(primaryKey) + "|" + BooleanUtils.toInteger(createdTracker) + "|" + BooleanUtils
            .toInteger(updatedTracker);
    }

    public String getDataTypeWithPrecisionAndScale() {
        return derivedDataType + (StringUtils.isNotBlank(precisionScale) ? "(" + precisionScale + ")" : "");
    }

    @Override
    public String getPrecisionScale() {
        return precisionScale;
    }

    public void setPrecisionScale(String precisionScale) {
        this.precisionScale = precisionScale;
    }

    @Override
    public Boolean getCreatedTracker() {
        return createdTracker;
    }

    public void setCreatedTracker(Boolean createdTracker) {
        this.createdTracker = createdTracker;
    }

    @Override
    public Boolean getUpdatedTracker() {
        return updatedTracker;
    }

    public void setUpdatedTracker(Boolean updatedTracker) {
        this.updatedTracker = updatedTracker;
    }
}
