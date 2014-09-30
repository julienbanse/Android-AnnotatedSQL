/* AUTO-GENERATED FILE.  DO NOT MODIFY.
 *
 * This class was automatically generated by the AnnotatedSQL library.
 */
package ${pkgName};

import android.database.Cursor;
import java.util.Date;
import ${tableCanonicalName};

public class ${cursorWrapperName} extends AbstractCursorWrapper {

    public ${cursorWrapperName}(Cursor cursor) {
        super(cursor);
    }

    <#list columnNameList as columnName>
    <#if columnName != "_ID">
    public ${getClassTypeForColumn(columnName)} get${convertInCamelCase(columnName)}() {
        <#switch getClassTypeForColumn(columnName)>
        <#case "Integer">
        return getIntegerOrNull(${tableClassName}.${columnName});
        <#break>
        <#case "int">
        return getInt(${tableClassName}.${columnName});
        <#break>
        <#case "Long">
        return getLongOrNull(${tableClassName}.${columnName});
        <#break>
        <#case "long">
        return getLong(${tableClassName}.${columnName});
        <#break>
        <#case "Float">
        return getFloatOrNull(${tableClassName}.${columnName});
        <#break>
        <#case "float">
        return getFloat(${tableClassName}.${columnName});
        <#break>
        <#case "double">
        return getDoubleOrNull(${tableClassName}.${columnName});
        <#break>
        <#case "Double">
        return getDouble(${tableClassName}.${columnName});
        <#break>
        <#case "Boolean">
        return getBooleanOrNull(${tableClassName}.${columnName});
        <#break>
        <#case "boolean">
        return getBoolean(${tableClassName}.${columnName});
        <#break>
        <#case "Date">
        return getDate(${tableClassName}.${columnName});
        <#break>
        <#case "byte[]">
        return getBlob(${tableClassName}.${columnName});
        <#break>
        <#case "String">
        <#default>
        return getString(${tableClassName}.${columnName});
        </#switch>
    }
    </#if>
    </#list>


}