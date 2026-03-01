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

/* server/status/variables/index.twig */
class __TwigTemplate_3632670faef876cb4cc58f238b4d5327 extends Template
{
    private $source;
    private $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->blocks = [
            'content' => [$this, 'block_content'],
        ];
    }

    protected function doGetParent(array $context)
    {
        // line 1
        return "server/status/base.twig";
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 2
        $context["active"] = "variables";
        // line 1
        $this->parent = $this->loadTemplate("server/status/base.twig", "server/status/variables/index.twig", 1);
        yield from $this->parent->unwrap()->yield($context, array_merge($this->blocks, $blocks));
    }

    // line 3
    public function block_content($context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 4
        yield "
";
        // line 5
        if (($context["is_data_loaded"] ?? null)) {
            // line 6
            yield "<div class=\"card mb-3\" id=\"tableFilter\">
  <div class=\"card-header\">";
yield _gettext("Filters");
            // line 7
            yield "</div>
  <div class=\"card-body\">
    <form action=\"";
            // line 9
            yield PhpMyAdmin\Url::getFromRoute("/server/status/variables");
            yield "\" method=\"post\" class=\"row row-cols-lg-auto g-3 align-items-center\">
      ";
            // line 10
            yield PhpMyAdmin\Url::getHiddenInputs();
            yield "

      <label class=\"col-12 col-form-label\" for=\"filterText\">";
yield _gettext("Containing the word:");
            // line 12
            yield "</label>
      <div class=\"col-12\">
        <input class=\"form-control\" name=\"filterText\" type=\"text\" id=\"filterText\" value=\"";
            // line 14
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["filter_text"] ?? null), "html", null, true);
            yield "\">
      </div>

      <div class=\"col-12\">
        <div class=\"form-check\">
          <input class=\"form-check-input\" type=\"checkbox\" name=\"filterAlert\" id=\"filterAlert\"";
            // line 19
            yield ((($context["is_only_alerts"] ?? null)) ? (" checked") : (""));
            yield ">
          <label class=\"form-check-label\" for=\"filterAlert\">";
yield _gettext("Show only alert values");
            // line 20
            yield "</label>
        </div>
      </div>

      <div class=\"col-12\">
        <label class=\"visually-hidden\" for=\"filterCategory\">";
yield _gettext("Filter by category…");
            // line 25
            yield "</label>
        <select class=\"form-select\" id=\"filterCategory\" name=\"filterCategory\">
          <option value=\"\">";
yield _gettext("Filter by category…");
            // line 27
            yield "</option>
          ";
            // line 28
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["categories"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["category"]) {
                // line 29
                yield "            <option value=\"";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["category"], "id", [], "any", false, false, false, 29), "html", null, true);
                yield "\"";
                yield ((CoreExtension::getAttribute($this->env, $this->source, $context["category"], "is_selected", [], "any", false, false, false, 29)) ? (" selected") : (""));
                yield ">";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["category"], "name", [], "any", false, false, false, 29), "html", null, true);
                yield "</option>
          ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['category'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 31
            yield "        </select>
      </div>

      <div class=\"col-12\">
        <div class=\"form-check\">
          <input class=\"form-check-input\" type=\"checkbox\" name=\"dontFormat\" id=\"dontFormat\"";
            // line 36
            yield ((($context["is_not_formatted"] ?? null)) ? (" checked") : (""));
            yield ">
          <label class=\"form-check-label\" for=\"dontFormat\">";
yield _gettext("Show unformatted values");
            // line 37
            yield "</label>
        </div>
      </div>

      <div class=\"col-12\">
        <input class=\"btn btn-secondary\" type=\"submit\" value=\"";
yield _gettext("Refresh");
            // line 42
            yield "\">
      </div>
    </form>
  </div>
</div>

  <div id=\"linkSuggestions\" class=\"defaultLinks hide\">
    <p class=\"alert alert-primary\" role=\"alert\">
      ";
yield _gettext("Related links:");
            // line 51
            yield "      ";
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["links"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["link"]) {
                // line 52
                yield "        <span class=\"";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["link"], "name", [], "any", false, false, false, 52), "html", null, true);
                yield "\">
          ";
                // line 53
                $context['_parent'] = $context;
                $context['_seq'] = CoreExtension::ensureTraversable(CoreExtension::getAttribute($this->env, $this->source, $context["link"], "links", [], "any", false, false, false, 53));
                foreach ($context['_seq'] as $context["link_name"] => $context["link_url"]) {
                    // line 54
                    yield "            ";
                    if (($context["link_name"] == "doc")) {
                        // line 55
                        yield "              ";
                        yield PhpMyAdmin\Html\MySQLDocumentation::show($context["link_url"]);
                        yield "
            ";
                    } else {
                        // line 57
                        yield "              <a href=\"";
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["link_url"], "url", [], "any", false, false, false, 57), "html", null, true);
                        yield "\"";
                        if ( !Twig\Extension\CoreExtension::testEmpty(CoreExtension::getAttribute($this->env, $this->source, $context["link_url"], "params", [], "any", false, false, false, 57))) {
                            yield " data-post=\"";
                            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["link_url"], "params", [], "any", false, false, false, 57), "html", null, true);
                            yield "\"";
                        }
                        yield ">";
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["link_name"], "html", null, true);
                        yield "</a>
            ";
                    }
                    // line 59
                    yield "            |
          ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['link_name'], $context['link_url'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 61
                yield "        </span>
      ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['link'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 63
            yield "    </p>
  </div>

  <div class=\"responsivetable row\">
    <table class=\"table table-striped table-hover table-sm\" id=\"serverStatusVariables\">
      <colgroup>
        <col class=\"namecol\">
        <col class=\"valuecol\">
        <col class=\"descrcol\">
      </colgroup>
      <thead>
        <tr>
          <th scope=\"col\">";
yield _gettext("Variable");
            // line 75
            yield "</th>
          <th scope=\"col\">";
yield _gettext("Value");
            // line 76
            yield "</th>
          <th scope=\"col\">";
yield _gettext("Description");
            // line 77
            yield "</th>
        </tr>
      </thead>
      <tbody>
        ";
            // line 81
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["variables"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["variable"]) {
                // line 82
                yield "          <tr";
                if ( !Twig\Extension\CoreExtension::testEmpty(CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "class", [], "any", false, false, false, 82))) {
                    yield " class=\"s_";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "class", [], "any", false, false, false, 82), "html", null, true);
                    yield "\"";
                }
                yield ">
            <th class=\"name\">
              ";
                // line 84
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::replace(CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "name", [], "any", false, false, false, 84), ["_" => " "]), "html", null, true);
                yield "
              ";
                // line 85
                yield CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "doc", [], "any", false, false, false, 85);
                yield "
            </th>

            <td class=\"value font-monospace text-end\">
              <span class=\"formatted\">
                ";
                // line 90
                if (CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "has_alert", [], "any", false, false, false, 90)) {
                    // line 91
                    yield "                  <span class=\"";
                    yield ((CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "is_alert", [], "any", false, false, false, 91)) ? ("text-danger") : ("text-success"));
                    yield "\">
                ";
                }
                // line 93
                yield "
                ";
                // line 94
                if ((is_string($__internal_compile_0 = CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "name", [], "any", false, false, false, 94)) && is_string($__internal_compile_1 = "%") && str_ends_with($__internal_compile_0, $__internal_compile_1))) {
                    // line 95
                    yield "                  ";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::formatNumber(CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "value", [], "any", false, false, false, 95), 0, 2), "html", null, true);
                    yield " %
                ";
                } elseif (CoreExtension::inFilter("Uptime", CoreExtension::getAttribute($this->env, $this->source,                 // line 96
$context["variable"], "name", [], "any", false, false, false, 96))) {
                    // line 97
                    yield "                  ";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::timespanFormat(CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "value", [], "any", false, false, false, 97)), "html", null, true);
                    yield "
                ";
                } elseif ((CoreExtension::getAttribute($this->env, $this->source,                 // line 98
$context["variable"], "is_numeric", [], "any", false, false, false, 98) && (CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "value", [], "any", false, false, false, 98) >= 1000))) {
                    // line 99
                    yield "                  <abbr title=\"";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::formatNumber(CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "value", [], "any", false, false, false, 99), 0), "html", null, true);
                    yield "\">
                    ";
                    // line 100
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::formatNumber(CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "value", [], "any", false, false, false, 100), 3, 1), "html", null, true);
                    yield "
                  </abbr>
                ";
                } elseif (CoreExtension::getAttribute($this->env, $this->source,                 // line 102
$context["variable"], "is_numeric", [], "any", false, false, false, 102)) {
                    // line 103
                    yield "                  ";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::formatNumber(CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "value", [], "any", false, false, false, 103), 3, 1), "html", null, true);
                    yield "
                ";
                } else {
                    // line 105
                    yield "                  ";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "value", [], "any", false, false, false, 105), "html", null, true);
                    yield "
                ";
                }
                // line 107
                yield "
                ";
                // line 108
                if (CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "has_alert", [], "any", false, false, false, 108)) {
                    // line 109
                    yield "                  </span>
                ";
                }
                // line 111
                yield "              </span>
              <span class=\"original hide\">
                ";
                // line 113
                if (CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "has_alert", [], "any", false, false, false, 113)) {
                    // line 114
                    yield "                  <span class=\"";
                    yield ((CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "is_alert", [], "any", false, false, false, 114)) ? ("text-danger") : ("text-success"));
                    yield "\">
                ";
                }
                // line 116
                yield "                ";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "value", [], "any", false, false, false, 116), "html", null, true);
                yield "
                ";
                // line 117
                if (CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "has_alert", [], "any", false, false, false, 117)) {
                    // line 118
                    yield "                  </span>
                ";
                }
                // line 120
                yield "              </span>
            </td>

            <td class=\"w-50\">
              ";
                // line 124
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "description", [], "any", false, false, false, 124), "html", null, true);
                yield "
              ";
                // line 125
                $context['_parent'] = $context;
                $context['_seq'] = CoreExtension::ensureTraversable(CoreExtension::getAttribute($this->env, $this->source, $context["variable"], "description_doc", [], "any", false, false, false, 125));
                foreach ($context['_seq'] as $context["_key"] => $context["doc"]) {
                    // line 126
                    yield "                ";
                    if ((CoreExtension::getAttribute($this->env, $this->source, $context["doc"], "name", [], "any", false, false, false, 126) == "doc")) {
                        // line 127
                        yield "                  ";
                        yield PhpMyAdmin\Html\MySQLDocumentation::show(CoreExtension::getAttribute($this->env, $this->source, $context["doc"], "url", [], "any", false, false, false, 127));
                        yield "
                ";
                    } else {
                        // line 129
                        yield "                  <a href=\"";
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, CoreExtension::getAttribute($this->env, $this->source, $context["doc"], "url", [], "any", false, false, false, 129), "url", [], "any", false, false, false, 129), "html", null, true);
                        yield "\" data-post=\"";
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, CoreExtension::getAttribute($this->env, $this->source, $context["doc"], "url", [], "any", false, false, false, 129), "params", [], "any", false, false, false, 129), "html", null, true);
                        yield "\">";
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["doc"], "name", [], "any", false, false, false, 129), "html", null, true);
                        yield "</a>
                ";
                    }
                    // line 131
                    yield "              ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['doc'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 132
                yield "            </td>
          </tr>
        ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['variable'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 135
            yield "      </tbody>
    </table>
  </div>
";
        } else {
            // line 139
            yield "  ";
            yield $this->env->getFilter('error')->getCallable()(_gettext("Not enough privilege to view status variables."));
            yield "
";
        }
        // line 141
        yield "
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "server/status/variables/index.twig";
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
        return array (  406 => 141,  400 => 139,  394 => 135,  386 => 132,  380 => 131,  370 => 129,  364 => 127,  361 => 126,  357 => 125,  353 => 124,  347 => 120,  343 => 118,  341 => 117,  336 => 116,  330 => 114,  328 => 113,  324 => 111,  320 => 109,  318 => 108,  315 => 107,  309 => 105,  303 => 103,  301 => 102,  296 => 100,  291 => 99,  289 => 98,  284 => 97,  282 => 96,  277 => 95,  275 => 94,  272 => 93,  266 => 91,  264 => 90,  256 => 85,  252 => 84,  242 => 82,  238 => 81,  232 => 77,  228 => 76,  224 => 75,  209 => 63,  202 => 61,  195 => 59,  181 => 57,  175 => 55,  172 => 54,  168 => 53,  163 => 52,  158 => 51,  147 => 42,  139 => 37,  134 => 36,  127 => 31,  114 => 29,  110 => 28,  107 => 27,  102 => 25,  94 => 20,  89 => 19,  81 => 14,  77 => 12,  71 => 10,  67 => 9,  63 => 7,  59 => 6,  57 => 5,  54 => 4,  50 => 3,  45 => 1,  43 => 2,  36 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "server/status/variables/index.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\server\\status\\variables\\index.twig");
    }
}
