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

/* database/operations/index.twig */
class __TwigTemplate_e2694bcce6bfa1e8af549753c9a1919d extends Template
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
        yield "<div class=\"container-fluid\">

  ";
        // line 3
        yield ($context["message"] ?? null);
        yield "

  ";
        // line 5
        if (($context["has_comment"] ?? null)) {
            // line 6
            yield "    <form method=\"post\" action=\"";
            yield PhpMyAdmin\Url::getFromRoute("/database/operations");
            yield "\" id=\"formDatabaseComment\">
      ";
            // line 7
            yield PhpMyAdmin\Url::getHiddenInputs(($context["db"] ?? null));
            yield "
      <div class=\"card mb-2\">
        <div class=\"card-header\">";
            // line 9
            yield PhpMyAdmin\Html\Generator::getIcon("b_comment", _gettext("Database comment"), true);
            yield "</div>
        <div class=\"card-body\">
          <div class=\"row g-3\">
            <div class=\"col-auto\">
              <label class=\"visually-hidden\" for=\"databaseCommentInput\">";
yield _gettext("Database comment");
            // line 13
            yield "</label>
              <input class=\"form-control textfield\" id=\"databaseCommentInput\" type=\"text\" name=\"comment\" value=\"";
            // line 14
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["db_comment"] ?? null), "html", null, true);
            yield "\">
            </div>
          </div>
        </div>
        <div class=\"card-footer text-end\">
          <input class=\"btn btn-primary\" type=\"submit\" value=\"";
yield _gettext("Go");
            // line 19
            yield "\">
        </div>
      </div>
    </form>
  ";
        }
        // line 24
        yield "
  <form id=\"createTableMinimalForm\" method=\"post\" action=\"";
        // line 25
        yield PhpMyAdmin\Url::getFromRoute("/table/create");
        yield "\" class=\"card mb-2 lock-page\">
    ";
        // line 26
        yield PhpMyAdmin\Url::getHiddenInputs(($context["db"] ?? null));
        yield "
    <div class=\"card-header\">";
        // line 27
        yield PhpMyAdmin\Html\Generator::getIcon("b_table_add", _gettext("Create new table"), true);
        yield "</div>
    <div class=\"card-body row row-cols-lg-auto g-3\">
      <div class=\"col-md-6\">
        <label for=\"createTableNameInput\" class=\"form-label\">";
yield _gettext("Table name");
        // line 30
        yield "</label>
        <input type=\"text\" class=\"form-control\" name=\"table\" id=\"createTableNameInput\" maxlength=\"64\" required>
      </div>
      <div class=\"col-md-6\">
        <label for=\"createTableNumFieldsInput\" class=\"form-label\">";
yield _gettext("Number of columns");
        // line 34
        yield "</label>
        <input type=\"number\" class=\"form-control\" name=\"num_fields\" id=\"createTableNumFieldsInput\" min=\"1\" value=\"4\" required>
      </div>
    </div>
    <div class=\"card-footer text-end\">
      <input class=\"btn btn-primary\" type=\"submit\" value=\"";
yield _gettext("Create");
        // line 39
        yield "\">
    </div>
  </form>

  ";
        // line 43
        if ((($context["db"] ?? null) != "mysql")) {
            // line 44
            yield "    <form id=\"rename_db_form\" class=\"ajax\" method=\"post\" action=\"";
            yield PhpMyAdmin\Url::getFromRoute("/database/operations");
            yield "\">
      ";
            // line 45
            yield PhpMyAdmin\Url::getHiddenInputs(($context["db"] ?? null));
            yield "
      <input type=\"hidden\" name=\"what\" value=\"data\">
      <input type=\"hidden\" name=\"db_rename\" value=\"true\">

      ";
            // line 49
            if ( !Twig\Extension\CoreExtension::testEmpty(($context["db_collation"] ?? null))) {
                // line 50
                yield "        <input type=\"hidden\" name=\"db_collation\" value=\"";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["db_collation"] ?? null), "html", null, true);
                yield "\">
      ";
            }
            // line 52
            yield "
      <div class=\"card mb-2\">
        <div class=\"card-header\">";
            // line 54
            yield PhpMyAdmin\Html\Generator::getIcon("b_edit", _gettext("Rename database to"), true);
            yield "</div>
        <div class=\"card-body\">
          <div class=\"mb-3 row g-3\">
            <div class=\"col-auto\">
              <label class=\"visually-hidden\" for=\"new_db_name\">";
yield _gettext("New database name");
            // line 58
            yield "</label>
              <input class=\"form-control textfield\" id=\"new_db_name\" type=\"text\" name=\"newname\" maxlength=\"64\" value=\"";
            // line 59
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["db"] ?? null), "html", null, true);
            yield "\" required>
            </div>
          </div>

          <div class=\"form-check\">
            <input class=\"form-check-input\" type=\"checkbox\" name=\"adjust_privileges\" value=\"1\" id=\"checkbox_adjust_privileges\"";
            // line 65
            if (($context["has_adjust_privileges"] ?? null)) {
                yield " checked";
            } else {
                yield " title=\"";
yield _gettext("You don't have sufficient privileges to perform this operation; Please refer to the documentation for more details.");
                // line 66
                yield "\" disabled";
            }
            yield ">
            <label class=\"form-check-label\" for=\"checkbox_adjust_privileges\">
              ";
yield _gettext("Adjust privileges");
            // line 69
            yield "              ";
            yield PhpMyAdmin\Html\MySQLDocumentation::showDocumentation("faq", "faq6-39");
            yield "
            </label>
          </div>
        </div>

        <div class=\"card-footer text-end\">
          <input class=\"btn btn-primary\" type=\"submit\" value=\"";
yield _gettext("Go");
            // line 75
            yield "\">
        </div>
      </div>
    </form>
  ";
        }
        // line 80
        yield "
  ";
        // line 81
        if (($context["is_drop_database_allowed"] ?? null)) {
            // line 82
            yield "    <div class=\"card mb-2\">
      <div class=\"card-header\">";
            // line 83
            yield PhpMyAdmin\Html\Generator::getIcon("b_deltbl", _gettext("Remove database"), true);
            yield "</div>
      <div class=\"card-body\">
        <div class=\"card-text\">
          ";
            // line 86
            yield PhpMyAdmin\Html\Generator::linkOrButton(PhpMyAdmin\Url::getFromRoute("/sql"), ["sql_query" => ("DROP DATABASE " . PhpMyAdmin\Util::backquote(            // line 89
($context["db"] ?? null))), "back" => PhpMyAdmin\Url::getFromRoute("/database/operations"), "goto" => PhpMyAdmin\Url::getFromRoute("/"), "reload" => true, "purge" => true, "message_to_show" => $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf(_gettext("Database %s has been dropped."), PhpMyAdmin\Util::backquote(            // line 94
($context["db"] ?? null)))), "db" => null], _gettext("Drop the database (DROP)"), ["id" => "drop_db_anchor", "class" => "ajax text-danger"]);
            // line 102
            yield "
          ";
            // line 103
            yield PhpMyAdmin\Html\MySQLDocumentation::show("DROP_DATABASE");
            yield "
        </div>
      </div>
    </div>
  ";
        }
        // line 108
        yield "
  <form id=\"copy_db_form\" class=\"ajax\" method=\"post\" action=\"";
        // line 109
        yield PhpMyAdmin\Url::getFromRoute("/database/operations");
        yield "\">
    ";
        // line 110
        yield PhpMyAdmin\Url::getHiddenInputs(($context["db"] ?? null));
        yield "
    <input type=\"hidden\" name=\"db_copy\" value=\"true\">

    ";
        // line 113
        if ( !Twig\Extension\CoreExtension::testEmpty(($context["db_collation"] ?? null))) {
            // line 114
            yield "      <input type=\"hidden\" name=\"db_collation\" value=\"";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["db_collation"] ?? null), "html", null, true);
            yield "\">
    ";
        }
        // line 116
        yield "
    <div class=\"card mb-2\">
      <div class=\"card-header\">";
        // line 118
        yield PhpMyAdmin\Html\Generator::getIcon("b_edit", _gettext("Copy database to"), true);
        yield "</div>
      <div class=\"card-body\">
        <div class=\"mb-3 row g-3\">
          <div class=\"col-auto\">
            <label class=\"visually-hidden\" for=\"renameDbNameInput\">";
yield _gettext("Database name");
        // line 122
        yield "</label>
            <input class=\"form-control textfield\" id=\"renameDbNameInput\" type=\"text\" name=\"newname\" maxlength=\"64\" value=\"";
        // line 123
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["db"] ?? null), "html", null, true);
        yield "\" required>
          </div>
        </div>

        <div class=\"mb-3\">
          <div class=\"form-check\">
            <input class=\"form-check-input\" type=\"radio\" name=\"what\" id=\"whatRadio1\" value=\"structure\">
            <label class=\"form-check-label\" for=\"whatRadio1\">
              ";
yield _gettext("Structure only");
        // line 132
        yield "            </label>
          </div>
          <div class=\"form-check\">
            <input class=\"form-check-input\" type=\"radio\" name=\"what\" id=\"whatRadio2\" value=\"data\" checked>
            <label class=\"form-check-label\" for=\"whatRadio2\">
              ";
yield _gettext("Structure and data");
        // line 138
        yield "            </label>
          </div>
          <div class=\"form-check\">
            <input class=\"form-check-input\" type=\"radio\" name=\"what\" id=\"whatRadio3\" value=\"dataonly\">
            <label class=\"form-check-label\" for=\"whatRadio3\">
              ";
yield _gettext("Data only");
        // line 144
        yield "            </label>
          </div>
        </div>

        <div class=\"form-check\">
          <input class=\"form-check-input\" type=\"checkbox\" name=\"create_database_before_copying\" value=\"1\" id=\"checkbox_create_database_before_copying\" checked>
          <label class=\"form-check-label\" for=\"checkbox_create_database_before_copying\">";
yield _gettext("CREATE DATABASE before copying");
        // line 150
        yield "</label>
        </div>

        <div class=\"form-check\">
          <input class=\"form-check-input\" type=\"checkbox\" name=\"drop_if_exists\" value=\"true\" id=\"checkbox_drop\">
          <label class=\"form-check-label\" for=\"checkbox_drop\">";
        // line 155
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf(_gettext("Add %s"), "DROP TABLE / DROP VIEW"), "html", null, true);
        yield "</label>
        </div>

        <div class=\"form-check\">
          <input class=\"form-check-input\" type=\"checkbox\" name=\"sql_auto_increment\" value=\"1\" id=\"checkbox_auto_increment\" checked>
          <label class=\"form-check-label\" for=\"checkbox_auto_increment\">";
yield _gettext("Add AUTO_INCREMENT value");
        // line 160
        yield "</label>
        </div>

        <div class=\"form-check\">
          <input class=\"form-check-input\" type=\"checkbox\" name=\"add_constraints\" value=\"1\" id=\"checkbox_constraints\" checked>
          <label class=\"form-check-label\" for=\"checkbox_constraints\">";
yield _gettext("Add constraints");
        // line 165
        yield "</label>
        </div>

        <div class=\"form-check\">
          <input class=\"form-check-input\" type=\"checkbox\" name=\"adjust_privileges\" value=\"1\" id=\"checkbox_privileges\"";
        // line 170
        if (($context["has_adjust_privileges"] ?? null)) {
            yield " checked";
        } else {
            yield " title=\"";
yield _gettext("You don't have sufficient privileges to perform this operation; Please refer to the documentation for more details.");
            // line 171
            yield "\" disabled";
        }
        yield ">
          <label class=\"form-check-label\" for=\"checkbox_privileges\">
            ";
yield _gettext("Adjust privileges");
        // line 174
        yield "            ";
        yield PhpMyAdmin\Html\MySQLDocumentation::showDocumentation("faq", "faq6-39");
        yield "
          </label>
        </div>

        <div class=\"form-check\">
          <input class=\"form-check-input\" type=\"checkbox\" name=\"switch_to_new\" value=\"true\" id=\"checkbox_switch\"";
        // line 179
        yield ((($context["switch_to_new"] ?? null)) ? (" checked") : (""));
        yield ">
          <label class=\"form-check-label\" for=\"checkbox_switch\">";
yield _gettext("Switch to copied database");
        // line 180
        yield "</label>
        </div>
      </div>

      <div class=\"card-footer text-end\">
        <input class=\"btn btn-primary\" type=\"submit\" name=\"submit_copy\" value=\"";
yield _gettext("Go");
        // line 185
        yield "\">
      </div>
    </div>
  </form>

  <form id=\"change_db_charset_form\" class=\"ajax\" method=\"post\" action=\"";
        // line 190
        yield PhpMyAdmin\Url::getFromRoute("/database/operations/collation");
        yield "\">
    ";
        // line 191
        yield PhpMyAdmin\Url::getHiddenInputs(($context["db"] ?? null));
        yield "

    <div class=\"card mb-2\">
      <div class=\"card-header\">";
        // line 194
        yield PhpMyAdmin\Html\Generator::getIcon("s_asci", _gettext("Collation"), true);
        yield "</div>
      <div class=\"card-body\">
        <div class=\"mb-3 row g-3\">
          <div class=\"col-auto\">
            <label class=\"visually-hidden\" for=\"select_db_collation\">";
yield _gettext("Collation");
        // line 198
        yield "</label>
            <select class=\"form-select\" lang=\"en\" dir=\"ltr\" name=\"db_collation\" id=\"select_db_collation\">
              <option value=\"\"></option>
              ";
        // line 201
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(($context["charsets"] ?? null));
        foreach ($context['_seq'] as $context["_key"] => $context["charset"]) {
            // line 202
            yield "                <optgroup label=\"";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["charset"], "getName", [], "method", false, false, false, 202), "html", null, true);
            yield "\" title=\"";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["charset"], "getDescription", [], "method", false, false, false, 202), "html", null, true);
            yield "\">
                  ";
            // line 203
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable((($__internal_compile_0 = ($context["collations"] ?? null)) && is_array($__internal_compile_0) || $__internal_compile_0 instanceof ArrayAccess ? ($__internal_compile_0[CoreExtension::getAttribute($this->env, $this->source, $context["charset"], "getName", [], "method", false, false, false, 203)] ?? null) : null));
            foreach ($context['_seq'] as $context["_key"] => $context["collation"]) {
                // line 204
                yield "                    <option value=\"";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["collation"], "getName", [], "method", false, false, false, 204), "html", null, true);
                yield "\" title=\"";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["collation"], "getDescription", [], "method", false, false, false, 204), "html", null, true);
                yield "\"";
                yield (((($context["db_collation"] ?? null) == CoreExtension::getAttribute($this->env, $this->source, $context["collation"], "getName", [], "method", false, false, false, 204))) ? (" selected") : (""));
                yield ">
                      ";
                // line 205
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["collation"], "getName", [], "method", false, false, false, 205), "html", null, true);
                yield "
                    </option>
                  ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['collation'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 208
            yield "                </optgroup>
              ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['charset'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 210
        yield "            </select>
          </div>
        </div>

        <div class=\"form-check\">
          <input class=\"form-check-input\" type=\"checkbox\" name=\"change_all_tables_collations\" id=\"checkbox_change_all_tables_collations\">
          <label class=\"form-check-label\" for=\"checkbox_change_all_tables_collations\">";
yield _gettext("Change all tables collations");
        // line 216
        yield "</label>
        </div>
        <div class=\"form-check\" id=\"span_change_all_tables_columns_collations\">
          <input class=\"form-check-input\" type=\"checkbox\" name=\"change_all_tables_columns_collations\" id=\"checkbox_change_all_tables_columns_collations\">
          <label class=\"form-check-label\" for=\"checkbox_change_all_tables_columns_collations\">";
yield _gettext("Change all tables columns collations");
        // line 220
        yield "</label>
        </div>
      </div>

      <div class=\"card-footer text-end\">
        <input class=\"btn btn-primary\" type=\"submit\" value=\"";
yield _gettext("Go");
        // line 225
        yield "\">
      </div>
    </div>
  </form>

</div>
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "database/operations/index.twig";
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
        return array (  462 => 225,  454 => 220,  447 => 216,  438 => 210,  431 => 208,  422 => 205,  413 => 204,  409 => 203,  402 => 202,  398 => 201,  393 => 198,  385 => 194,  379 => 191,  375 => 190,  368 => 185,  360 => 180,  355 => 179,  346 => 174,  339 => 171,  333 => 170,  327 => 165,  319 => 160,  310 => 155,  303 => 150,  294 => 144,  286 => 138,  278 => 132,  266 => 123,  263 => 122,  255 => 118,  251 => 116,  245 => 114,  243 => 113,  237 => 110,  233 => 109,  230 => 108,  222 => 103,  219 => 102,  217 => 94,  216 => 89,  215 => 86,  209 => 83,  206 => 82,  204 => 81,  201 => 80,  194 => 75,  183 => 69,  176 => 66,  170 => 65,  162 => 59,  159 => 58,  151 => 54,  147 => 52,  141 => 50,  139 => 49,  132 => 45,  127 => 44,  125 => 43,  119 => 39,  111 => 34,  104 => 30,  97 => 27,  93 => 26,  89 => 25,  86 => 24,  79 => 19,  70 => 14,  67 => 13,  59 => 9,  54 => 7,  49 => 6,  47 => 5,  42 => 3,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "database/operations/index.twig", "C:\\Users\\user\\Desktop\\vizsgahoz szukseges\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\database\\operations\\index.twig");
    }
}
