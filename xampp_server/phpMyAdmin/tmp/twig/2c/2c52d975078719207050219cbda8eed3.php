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

/* indexes.twig */
class __TwigTemplate_e0adfd604f46e66b3a4e80c1243926dd extends Template
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
        yield "<fieldset class=\"pma-fieldset index_info\">
  <legend id=\"index_header\">
    ";
yield _gettext("Indexes");
        // line 4
        yield "    ";
        yield PhpMyAdmin\Html\MySQLDocumentation::show("optimizing-database-structure");
        yield "
  </legend>

  ";
        // line 7
        if ( !Twig\Extension\CoreExtension::testEmpty(($context["indexes"] ?? null))) {
            // line 8
            yield "    ";
            yield ($context["indexes_duplicates"] ?? null);
            yield "

    ";
            // line 10
            yield Twig\Extension\CoreExtension::include($this->env, $context, "modals/preview_sql_confirmation.twig");
            yield "
    <div class=\"table-responsive jsresponsive\">
      <table class=\"table table-striped table-hover table-sm w-auto align-middle\" id=\"table_index\">
        <thead>
        <tr>
            <th colspan=\"3\" class=\"d-print-none\">";
yield _gettext("Action");
            // line 15
            yield "</th>
            <th>";
yield _gettext("Keyname");
            // line 16
            yield "</th>
            <th>";
yield _gettext("Type");
            // line 17
            yield "</th>
            <th>";
yield _gettext("Unique");
            // line 18
            yield "</th>
            <th>";
yield _gettext("Packed");
            // line 19
            yield "</th>
            <th>";
yield _gettext("Column");
            // line 20
            yield "</th>
            <th>";
yield _gettext("Cardinality");
            // line 21
            yield "</th>
            <th>";
yield _gettext("Collation");
            // line 22
            yield "</th>
            <th>";
yield _gettext("Null");
            // line 23
            yield "</th>
            <th>";
yield _gettext("Comment");
            // line 24
            yield "</th>
          </tr>
        </thead>

        ";
            // line 28
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["indexes"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["index"]) {
                // line 29
                yield "          <tbody class=\"row_span\">
            ";
                // line 30
                $context["columns_count"] = CoreExtension::getAttribute($this->env, $this->source, $context["index"], "getColumnCount", [], "method", false, false, false, 30);
                // line 31
                yield "            <tr class=\"noclick\">
              <td rowspan=\"";
                // line 32
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["columns_count"] ?? null), "html", null, true);
                yield "\" class=\"edit_index d-print-none ajax\">
                <a class=\"ajax\" href=\"";
                // line 33
                yield PhpMyAdmin\Url::getFromRoute("/table/indexes");
                yield "\" data-post=\"";
                yield PhpMyAdmin\Url::getCommon(Twig\Extension\CoreExtension::merge(($context["url_params"] ?? null), ["index" => CoreExtension::getAttribute($this->env, $this->source, $context["index"], "getName", [], "method", false, false, false, 33)]), "", false);
                yield "\">
                  ";
                // line 34
                yield PhpMyAdmin\Html\Generator::getIcon("b_edit", _gettext("Edit"));
                yield "
                </a>
              </td>
              <td rowspan=\"";
                // line 37
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["columns_count"] ?? null), "html", null, true);
                yield "\" class=\"rename_index d-print-none ajax\" >
                <a class=\"ajax\" href=\"";
                // line 38
                yield PhpMyAdmin\Url::getFromRoute("/table/indexes/rename");
                yield "\" data-post=\"";
                yield PhpMyAdmin\Url::getCommon(Twig\Extension\CoreExtension::merge(($context["url_params"] ?? null), ["index" => CoreExtension::getAttribute($this->env, $this->source, $context["index"], "getName", [], "method", false, false, false, 38)]), "", false);
                yield "\">
                  ";
                // line 39
                yield PhpMyAdmin\Html\Generator::getIcon("b_rename", _gettext("Rename"));
                yield "
                </a>
              </td>
              <td rowspan=\"";
                // line 42
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["columns_count"] ?? null), "html", null, true);
                yield "\" class=\"d-print-none\">
                ";
                // line 43
                if ((CoreExtension::getAttribute($this->env, $this->source, $context["index"], "getName", [], "method", false, false, false, 43) == "PRIMARY")) {
                    // line 44
                    yield "                  ";
                    $context["index_params"] = ["sql_query" => (("ALTER TABLE " . PhpMyAdmin\Util::backquote(                    // line 45
($context["table"] ?? null))) . " DROP PRIMARY KEY;"), "message_to_show" => _gettext("The primary key has been dropped.")];
                    // line 48
                    yield "                ";
                } else {
                    // line 49
                    yield "                  ";
                    $context["index_params"] = ["sql_query" => (((("ALTER TABLE " . PhpMyAdmin\Util::backquote(                    // line 50
($context["table"] ?? null))) . " DROP INDEX ") . PhpMyAdmin\Util::backquote(CoreExtension::getAttribute($this->env, $this->source, $context["index"], "getName", [], "method", false, false, false, 50))) . ";"), "message_to_show" => Twig\Extension\CoreExtension::sprintf(_gettext("Index %s has been dropped."), CoreExtension::getAttribute($this->env, $this->source,                     // line 51
$context["index"], "getName", [], "method", false, false, false, 51))];
                    // line 53
                    yield "                ";
                }
                // line 54
                yield "
                <input type=\"hidden\" class=\"drop_primary_key_index_msg\" value=\"";
                // line 55
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, ($context["index_params"] ?? null), "sql_query", [], "any", false, false, false, 55), "html", null, true);
                yield "\">
                ";
                // line 56
                yield PhpMyAdmin\Html\Generator::linkOrButton(PhpMyAdmin\Url::getFromRoute("/sql"), Twig\Extension\CoreExtension::merge(                // line 58
($context["url_params"] ?? null), ($context["index_params"] ?? null)), PhpMyAdmin\Html\Generator::getIcon("b_drop", _gettext("Drop")), ["class" => "drop_primary_key_index_anchor ajax"]);
                // line 61
                yield "
              </td>
              <th rowspan=\"";
                // line 63
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["columns_count"] ?? null), "html", null, true);
                yield "\">";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["index"], "getName", [], "method", false, false, false, 63), "html", null, true);
                yield "</th>
              <td rowspan=\"";
                // line 64
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["columns_count"] ?? null), "html", null, true);
                yield "\">";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(((CoreExtension::getAttribute($this->env, $this->source, $context["index"], "getType", [], "method", true, true, false, 64)) ? (Twig\Extension\CoreExtension::default(CoreExtension::getAttribute($this->env, $this->source, $context["index"], "getType", [], "method", false, false, false, 64), CoreExtension::getAttribute($this->env, $this->source, $context["index"], "getChoice", [], "method", false, false, false, 64))) : (CoreExtension::getAttribute($this->env, $this->source, $context["index"], "getChoice", [], "method", false, false, false, 64))), "html", null, true);
                yield "</td>
              <td rowspan=\"";
                // line 65
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["columns_count"] ?? null), "html", null, true);
                yield "\">";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(((CoreExtension::getAttribute($this->env, $this->source, $context["index"], "isUnique", [], "method", false, false, false, 65)) ? (_gettext("Yes")) : (_gettext("No"))), "html", null, true);
                yield "</td>
              <td rowspan=\"";
                // line 66
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["columns_count"] ?? null), "html", null, true);
                yield "\">";
                yield CoreExtension::getAttribute($this->env, $this->source, $context["index"], "isPacked", [], "method", false, false, false, 66);
                yield "</td>

              ";
                // line 68
                $context['_parent'] = $context;
                $context['_seq'] = CoreExtension::ensureTraversable(CoreExtension::getAttribute($this->env, $this->source, $context["index"], "getColumns", [], "method", false, false, false, 68));
                foreach ($context['_seq'] as $context["_key"] => $context["column"]) {
                    // line 69
                    yield "                ";
                    if ((CoreExtension::getAttribute($this->env, $this->source, $context["column"], "getSeqInIndex", [], "method", false, false, false, 69) > 1)) {
                        // line 70
                        yield "                  <tr class=\"noclick\">
                ";
                    }
                    // line 72
                    yield "                <td>
                  ";
                    // line 73
                    if (CoreExtension::getAttribute($this->env, $this->source, $context["column"], "hasExpression", [], "method", false, false, false, 73)) {
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["column"], "getExpression", [], "method", false, false, false, 73), "html", null, true);
                    } else {
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["column"], "getName", [], "method", false, false, false, 73), "html", null, true);
                    }
                    // line 74
                    yield "                  ";
                    if ( !Twig\Extension\CoreExtension::testEmpty(CoreExtension::getAttribute($this->env, $this->source, $context["column"], "getSubPart", [], "method", false, false, false, 74))) {
                        // line 75
                        yield "                    (";
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["column"], "getSubPart", [], "method", false, false, false, 75), "html", null, true);
                        yield ")
                  ";
                    }
                    // line 77
                    yield "                </td>
                <td>";
                    // line 78
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["column"], "getCardinality", [], "method", false, false, false, 78), "html", null, true);
                    yield "</td>
                <td>";
                    // line 79
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["column"], "getCollation", [], "method", false, false, false, 79), "html", null, true);
                    yield "</td>
                <td>";
                    // line 80
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["column"], "getNull", [true], "method", false, false, false, 80), "html", null, true);
                    yield "</td>

                ";
                    // line 82
                    if ((CoreExtension::getAttribute($this->env, $this->source, $context["column"], "getSeqInIndex", [], "method", false, false, false, 82) == 1)) {
                        // line 83
                        yield "                  <td rowspan=\"";
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["columns_count"] ?? null), "html", null, true);
                        yield "\">";
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["index"], "getComments", [], "method", false, false, false, 83), "html", null, true);
                        yield "</td>
                ";
                    }
                    // line 85
                    yield "            </tr>
              ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['column'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 87
                yield "          </tbody>
        ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['index'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 89
            yield "      </table>
    </div>
  ";
        } else {
            // line 92
            yield "    <div class=\"no_indexes_defined\">";
            yield $this->env->getFilter('notice')->getCallable()(_gettext("No index defined!"));
            yield "</div>
  ";
        }
        // line 94
        yield "</fieldset>
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "indexes.twig";
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
        return array (  293 => 94,  287 => 92,  282 => 89,  275 => 87,  268 => 85,  260 => 83,  258 => 82,  253 => 80,  249 => 79,  245 => 78,  242 => 77,  236 => 75,  233 => 74,  227 => 73,  224 => 72,  220 => 70,  217 => 69,  213 => 68,  206 => 66,  200 => 65,  194 => 64,  188 => 63,  184 => 61,  182 => 58,  181 => 56,  177 => 55,  174 => 54,  171 => 53,  169 => 51,  168 => 50,  166 => 49,  163 => 48,  161 => 45,  159 => 44,  157 => 43,  153 => 42,  147 => 39,  141 => 38,  137 => 37,  131 => 34,  125 => 33,  121 => 32,  118 => 31,  116 => 30,  113 => 29,  109 => 28,  103 => 24,  99 => 23,  95 => 22,  91 => 21,  87 => 20,  83 => 19,  79 => 18,  75 => 17,  71 => 16,  67 => 15,  58 => 10,  52 => 8,  50 => 7,  43 => 4,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "indexes.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\indexes.twig");
    }
}
