<?php

use Twig\Environment;
use Twig\Error\LoaderError;
use Twig\Error\RuntimeError;
use Twig\Extension\CoreExtension;
use Twig\Extension\SandboxExtension;
use Twig\Markup;
use Twig\Sandbox\SecurityError;
use Twig\Sandbox\SecurityNotAllowedTagError;
use Twig\Sandbox\SecurityNotAllowedFilterError;
use Twig\Sandbox\SecurityNotAllowedFunctionError;
use Twig\Source;
use Twig\Template;

/* columns_definitions/column_definitions_form.twig */
class __TwigTemplate_3fe83ad6d3567767bd142de5b34bba15 extends Template
{
    private $source;
    private $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->parent = false;

        $this->blocks = [
        ];
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 1
        yield "<form method=\"post\" action=\"";
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["action"] ?? null), "html", null, true);
        yield "\" class=\"";
        // line 2
        yield (((($context["action"] ?? null) == PhpMyAdmin\Url::getFromRoute("/table/create"))) ? ("create_table") : ("append_fields"));
        // line 3
        yield "_form ajax lock-page\">
    ";
        // line 4
        yield PhpMyAdmin\Url::getHiddenInputs(($context["form_params"] ?? null));
        yield "
    ";
        // line 6
        yield "    ";
        // line 7
        yield "    ";
        // line 8
        yield "    <input type=\"hidden\" name=\"primary_indexes\" value=\"";
        // line 9
        (( !Twig\Extension\CoreExtension::testEmpty(($context["primary_indexes"] ?? null))) ? (yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["primary_indexes"] ?? null), "html", null, true)) : (yield "[]"));
        yield "\">
    <input type=\"hidden\" name=\"unique_indexes\" value=\"";
        // line 11
        (( !Twig\Extension\CoreExtension::testEmpty(($context["unique_indexes"] ?? null))) ? (yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["unique_indexes"] ?? null), "html", null, true)) : (yield "[]"));
        yield "\">
    <input type=\"hidden\" name=\"indexes\" value=\"";
        // line 13
        (( !Twig\Extension\CoreExtension::testEmpty(($context["indexes"] ?? null))) ? (yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["indexes"] ?? null), "html", null, true)) : (yield "[]"));
        yield "\">
    <input type=\"hidden\" name=\"fulltext_indexes\" value=\"";
        // line 15
        (( !Twig\Extension\CoreExtension::testEmpty(($context["fulltext_indexes"] ?? null))) ? (yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["fulltext_indexes"] ?? null), "html", null, true)) : (yield "[]"));
        yield "\">
    <input type=\"hidden\" name=\"spatial_indexes\" value=\"";
        // line 17
        (( !Twig\Extension\CoreExtension::testEmpty(($context["spatial_indexes"] ?? null))) ? (yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["spatial_indexes"] ?? null), "html", null, true)) : (yield "[]"));
        yield "\">

    ";
        // line 19
        if ((($context["action"] ?? null) == PhpMyAdmin\Url::getFromRoute("/table/create"))) {
            // line 20
            yield "        <div id=\"table_name_col_no_outer\">
            <table id=\"table_name_col_no\" class=\"table table-borderless tdblock\">
                <tr class=\"align-middle float-start\">
                    <td>";
yield _gettext("Table name");
            // line 23
            yield ":
                    <input type=\"text\"
                        name=\"table\"
                        size=\"40\"
                        maxlength=\"64\"
                        value=\"";
            // line 28
            ((array_key_exists("table", $context)) ? (yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["table"] ?? null), "html", null, true)) : (yield ""));
            yield "\"
                        class=\"textfield\" autofocus required>
                    </td>
                    <td>
                        ";
yield _gettext("Add");
            // line 33
            yield "                        <input type=\"number\"
                            id=\"added_fields\"
                            name=\"added_fields\"
                            size=\"2\"
                            value=\"1\"
                            min=\"1\"
                            onfocus=\"this.select()\">
                        ";
yield _gettext("column(s)");
            // line 41
            yield "                        <input class=\"btn btn-secondary\" type=\"button\"
                            name=\"submit_num_fields\"
                            value=\"";
yield _gettext("Go");
            // line 43
            yield "\">
                    </td>
                </tr>
            </table>
        </div>
    ";
        }
        // line 49
        yield "    ";
        if (is_iterable(($context["content_cells"] ?? null))) {
            // line 50
            yield "        ";
            yield from             $this->loadTemplate("columns_definitions/table_fields_definitions.twig", "columns_definitions/column_definitions_form.twig", 50)->unwrap()->yield(CoreExtension::toArray(["is_backup" =>             // line 51
($context["is_backup"] ?? null), "fields_meta" =>             // line 52
($context["fields_meta"] ?? null), "relation_parameters" =>             // line 53
($context["relation_parameters"] ?? null), "content_cells" =>             // line 54
($context["content_cells"] ?? null), "change_column" =>             // line 55
($context["change_column"] ?? null), "is_virtual_columns_supported" =>             // line 56
($context["is_virtual_columns_supported"] ?? null), "server_version" =>             // line 57
($context["server_version"] ?? null), "browse_mime" =>             // line 58
($context["browse_mime"] ?? null), "supports_stored_keyword" =>             // line 59
($context["supports_stored_keyword"] ?? null), "max_rows" =>             // line 60
($context["max_rows"] ?? null), "char_editing" =>             // line 61
($context["char_editing"] ?? null), "attribute_types" =>             // line 62
($context["attribute_types"] ?? null), "privs_available" =>             // line 63
($context["privs_available"] ?? null), "max_length" =>             // line 64
($context["max_length"] ?? null), "charsets" =>             // line 65
($context["charsets"] ?? null)]));
            // line 67
            yield "    ";
        }
        // line 68
        yield "    ";
        if ((($context["action"] ?? null) == PhpMyAdmin\Url::getFromRoute("/table/create"))) {
            // line 69
            yield "        <div class=\"responsivetable\">
        <table class=\"table table-borderless w-auto align-middle mb-0\">
            <tr class=\"align-top\">
                <th>";
yield _gettext("Table comments:");
            // line 72
            yield "</th>
                <td width=\"25\">&nbsp;</td>
                <th>";
yield _gettext("Collation:");
            // line 74
            yield "</th>
                <td width=\"25\">&nbsp;</td>
                <th>
                    ";
yield _gettext("Storage Engine:");
            // line 78
            yield "                    ";
            yield PhpMyAdmin\Html\MySQLDocumentation::show("Storage_engines");
            yield "
                </th>
                <td width=\"25\">&nbsp;</td>
                <th id=\"storage-engine-connection\">
                    ";
yield _gettext("Connection:");
            // line 83
            yield "                    ";
            yield PhpMyAdmin\Html\MySQLDocumentation::show("federated-create-connection");
            yield "
                </th>
            </tr>
            <tr>
                <td>
                    <input type=\"text\"
                        name=\"comment\"
                        size=\"40\"
                        maxlength=\"60\"
                        value=\"";
            // line 92
            ((array_key_exists("comment", $context)) ? (yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["comment"] ?? null), "html", null, true)) : (yield ""));
            yield "\"
                        class=\"textfield\">
                </td>
                <td width=\"25\">&nbsp;</td>
                <td>
                  <select lang=\"en\" dir=\"ltr\" name=\"tbl_collation\">
                    <option value=\"\"></option>
                    ";
            // line 99
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["charsets"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["charset"]) {
                // line 100
                yield "                      <optgroup label=\"";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["charset"], "name", [], "any", false, false, false, 100), "html", null, true);
                yield "\" title=\"";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["charset"], "description", [], "any", false, false, false, 100), "html", null, true);
                yield "\">
                        ";
                // line 101
                $context['_parent'] = $context;
                $context['_seq'] = CoreExtension::ensureTraversable(CoreExtension::getAttribute($this->env, $this->source, $context["charset"], "collations", [], "any", false, false, false, 101));
                foreach ($context['_seq'] as $context["_key"] => $context["collation"]) {
                    // line 102
                    yield "                          <option value=\"";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["collation"], "name", [], "any", false, false, false, 102), "html", null, true);
                    yield "\" title=\"";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["collation"], "description", [], "any", false, false, false, 102), "html", null, true);
                    yield "\"";
                    // line 103
                    yield (((CoreExtension::getAttribute($this->env, $this->source, $context["collation"], "name", [], "any", false, false, false, 103) == ($context["tbl_collation"] ?? null))) ? (" selected") : (""));
                    yield ">";
                    // line 104
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["collation"], "name", [], "any", false, false, false, 104), "html", null, true);
                    // line 105
                    yield "</option>
                        ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['collation'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 107
                yield "                      </optgroup>
                    ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['charset'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 109
            yield "                  </select>
                </td>
                <td width=\"25\">&nbsp;</td>
                <td>
                  <select class=\"form-select\" name=\"tbl_storage_engine\" aria-label=\"";
yield _gettext("Storage engine");
            // line 113
            yield "\">
                    ";
            // line 114
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["storage_engines"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["engine"]) {
                // line 115
                yield "                      <option value=\"";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["engine"], "name", [], "any", false, false, false, 115), "html", null, true);
                yield "\"";
                if ( !Twig\Extension\CoreExtension::testEmpty(CoreExtension::getAttribute($this->env, $this->source, $context["engine"], "comment", [], "any", false, false, false, 115))) {
                    yield " title=\"";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["engine"], "comment", [], "any", false, false, false, 115), "html", null, true);
                    yield "\"";
                }
                // line 116
                yield ((((Twig\Extension\CoreExtension::lower($this->env->getCharset(), CoreExtension::getAttribute($this->env, $this->source, $context["engine"], "name", [], "any", false, false, false, 116)) == Twig\Extension\CoreExtension::lower($this->env->getCharset(), ($context["tbl_storage_engine"] ?? null))) || (Twig\Extension\CoreExtension::testEmpty(($context["tbl_storage_engine"] ?? null)) && CoreExtension::getAttribute($this->env, $this->source, $context["engine"], "is_default", [], "any", false, false, false, 116)))) ? (" selected") : (""));
                yield ">";
                // line 117
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["engine"], "name", [], "any", false, false, false, 117), "html", null, true);
                // line 118
                yield "</option>
                    ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['engine'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 120
            yield "                  </select>
                </td>
                <td width=\"25\">&nbsp;</td>
                <td>
                    <input type=\"text\"
                        name=\"connection\"
                        size=\"40\"
                        value=\"";
            // line 127
            ((array_key_exists("connection", $context)) ? (yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["connection"] ?? null), "html", null, true)) : (yield ""));
            yield "\"
                        placeholder=\"scheme://user_name[:password]@host_name[:port_num]/db_name/tbl_name\"
                        class=\"textfield\"
                        required=\"required\">
                </td>
            </tr>
            ";
            // line 133
            if (($context["have_partitioning"] ?? null)) {
                // line 134
                yield "                <tr class=\"align-top\">
                    <th colspan=\"5\">
                        ";
yield _gettext("PARTITION definition:");
                // line 137
                yield "                        ";
                yield PhpMyAdmin\Html\MySQLDocumentation::show("Partitioning");
                yield "
                    </th>
                </tr>
                <tr>
                    <td colspan=\"5\">
                        ";
                // line 142
                yield from                 $this->loadTemplate("columns_definitions/partitions.twig", "columns_definitions/column_definitions_form.twig", 142)->unwrap()->yield(CoreExtension::toArray(["partition_details" =>                 // line 143
($context["partition_details"] ?? null), "storage_engines" =>                 // line 144
($context["storage_engines"] ?? null)]));
                // line 146
                yield "                    </td>
                </tr>
            ";
            }
            // line 149
            yield "        </table>
        </div>
    ";
        }
        // line 152
        yield "    <fieldset class=\"pma-fieldset tblFooters\">
        ";
        // line 153
        if (((($context["action"] ?? null) == PhpMyAdmin\Url::getFromRoute("/table/add-field")) || (($context["action"] ?? null) == PhpMyAdmin\Url::getFromRoute("/table/structure/save")))) {
            // line 154
            yield "            <input type=\"checkbox\" name=\"online_transaction\" value=\"ONLINE_TRANSACTION_ENABLED\" />";
yield _pgettext("Online transaction part of the SQL DDL for InnoDB", "Online transaction");
            yield PhpMyAdmin\Html\MySQLDocumentation::show("innodb-online-ddl");
            yield "
        ";
        }
        // line 156
        yield "        <input class=\"btn btn-secondary preview_sql\" type=\"button\"
            value=\"";
yield _gettext("Preview SQL");
        // line 157
        yield "\">
        <input class=\"btn btn-primary\" type=\"submit\"
            name=\"do_save_data\"
            value=\"";
yield _gettext("Save");
        // line 160
        yield "\">
    </fieldset>
    <div id=\"properties_message\"></div>
     ";
        // line 163
        if (($context["is_integers_length_restricted"] ?? null)) {
            // line 164
            yield "        <div class=\"alert alert-primary\" id=\"length_not_allowed\" role=\"alert\">
            ";
            // line 165
            yield PhpMyAdmin\Html\Generator::getImage("s_notice");
            yield "
            ";
yield _gettext("The column width of integer types is ignored in your MySQL version unless defining a TINYINT(1) column");
            // line 167
            yield "            ";
            yield PhpMyAdmin\Html\MySQLDocumentation::show("", false, "https://dev.mysql.com/doc/relnotes/mysql/8.0/en/news-8-0-19.html");
            yield "
        </div>
     ";
        }
        // line 170
        yield "</form>
<div class=\"modal fade\" id=\"previewSqlModal\" tabindex=\"-1\" aria-labelledby=\"previewSqlModalLabel\" aria-hidden=\"true\">
  <div class=\"modal-dialog\">
    <div class=\"modal-content\">
      <div class=\"modal-header\">
        <h5 class=\"modal-title\" id=\"previewSqlModalLabel\">";
yield _gettext("Loading");
        // line 175
        yield "</h5>
        <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"";
yield _gettext("Close");
        // line 176
        yield "\"></button>
      </div>
      <div class=\"modal-body\">
      </div>
      <div class=\"modal-footer\">
        <button type=\"button\" class=\"btn btn-secondary\" id=\"previewSQLCloseButton\" data-bs-dismiss=\"modal\">";
yield _gettext("Close");
        // line 181
        yield "</button>
      </div>
    </div>
  </div>
</div>

";
        // line 188
        yield Twig\Extension\CoreExtension::include($this->env, $context, "modals/enum_set_editor.twig");
        yield "
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "columns_definitions/column_definitions_form.twig";
    }

    /**
     * @codeCoverageIgnore
     */
    public function isTraitable()
    {
        return false;
    }

    /**
     * @codeCoverageIgnore
     */
    public function getDebugInfo()
    {
        return array (  395 => 188,  387 => 181,  379 => 176,  375 => 175,  367 => 170,  360 => 167,  355 => 165,  352 => 164,  350 => 163,  345 => 160,  339 => 157,  335 => 156,  328 => 154,  326 => 153,  323 => 152,  318 => 149,  313 => 146,  311 => 144,  310 => 143,  309 => 142,  300 => 137,  295 => 134,  293 => 133,  284 => 127,  275 => 120,  268 => 118,  266 => 117,  263 => 116,  254 => 115,  250 => 114,  247 => 113,  240 => 109,  233 => 107,  226 => 105,  224 => 104,  221 => 103,  215 => 102,  211 => 101,  204 => 100,  200 => 99,  190 => 92,  177 => 83,  168 => 78,  162 => 74,  157 => 72,  151 => 69,  148 => 68,  145 => 67,  143 => 65,  142 => 64,  141 => 63,  140 => 62,  139 => 61,  138 => 60,  137 => 59,  136 => 58,  135 => 57,  134 => 56,  133 => 55,  132 => 54,  131 => 53,  130 => 52,  129 => 51,  127 => 50,  124 => 49,  116 => 43,  111 => 41,  101 => 33,  93 => 28,  86 => 23,  80 => 20,  78 => 19,  73 => 17,  69 => 15,  65 => 13,  61 => 11,  57 => 9,  55 => 8,  53 => 7,  51 => 6,  47 => 4,  44 => 3,  42 => 2,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "columns_definitions/column_definitions_form.twig", "C:\\Users\\user\\Desktop\\vizsgahoz szukseges\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\columns_definitions\\column_definitions_form.twig");
    }
}
