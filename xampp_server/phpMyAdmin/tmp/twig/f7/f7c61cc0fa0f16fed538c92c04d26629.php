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

/* server/status/advisor/index.twig */
class __TwigTemplate_476170153bc0ba9bc92d12e3084603df extends Template
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
        $context["active"] = "advisor";
        // line 1
        $this->parent = $this->loadTemplate("server/status/base.twig", "server/status/advisor/index.twig", 1);
        yield from $this->parent->unwrap()->yield($context, array_merge($this->blocks, $blocks));
    }

    // line 4
    public function block_content($context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 5
        yield "
  <h2>";
yield _gettext("Advisor system");
        // line 6
        yield "</h2>

  ";
        // line 8
        if (Twig\Extension\CoreExtension::testEmpty(($context["data"] ?? null))) {
            // line 9
            yield "    ";
            yield $this->env->getFilter('error')->getCallable()(_gettext("Not enough privilege to view the advisor."));
            yield "
  ";
        } else {
            // line 11
            yield "    <button type=\"button\" class=\"btn btn-secondary mb-4\" data-bs-toggle=\"modal\" data-bs-target=\"#advisorInstructionsModal\">
      ";
            // line 12
            yield PhpMyAdmin\Html\Generator::getIcon("b_help", _gettext("Instructions"));
            yield "
    </button>

    <div class=\"modal fade\" id=\"advisorInstructionsModal\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"advisorInstructionsModalLabel\" aria-hidden=\"true\">
      <div class=\"modal-dialog\" role=\"document\">
        <div class=\"modal-content\">
          <div class=\"modal-header\">
            <h5 class=\"modal-title\" id=\"advisorInstructionsModalLabel\">";
yield _gettext("Advisor system");
            // line 19
            yield "</h5>
            <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"";
yield _gettext("Close");
            // line 20
            yield "\"></button>
          </div>
          <div class=\"modal-body\">
            <p>";
yield _gettext("The Advisor system can provide recommendations on server variables by analyzing the server status variables.");
            // line 27
            yield "</p>
            <p>";
yield _gettext("Do note however that this system provides recommendations based on simple calculations and by rule of thumb which may not necessarily apply to your system.");
            // line 32
            yield "</p>
            <p>";
yield _gettext("Prior to changing any of the configuration, be sure to know what you are changing (by reading the documentation) and how to undo the change. Wrong tuning can have a very negative effect on performance.");
            // line 37
            yield "</p>
            <p>";
yield _gettext("The best way to tune your system would be to change only one setting at a time, observe or benchmark your database, and undo the change if there was no clearly measurable improvement.");
            // line 42
            yield "</p>
          </div>
          <div class=\"modal-footer\">
            <button type=\"button\" class=\"btn btn-primary\" data-bs-dismiss=\"modal\">";
yield _gettext("Close");
            // line 45
            yield "</button>
          </div>
        </div>
      </div>
    </div>

    ";
            // line 51
            if ((Twig\Extension\CoreExtension::length($this->env->getCharset(), CoreExtension::getAttribute($this->env, $this->source, ($context["data"] ?? null), "errors", [], "any", false, false, false, 51)) > 0)) {
                // line 52
                yield "      <div class=\"alert alert-danger mt-2 mb-2\" role=\"alert\">
        <h4 class=\"alert-heading\">";
yield _gettext("Errors occurred while executing rule expressions:");
                // line 53
                yield "</h4>
        <ul>
          ";
                // line 55
                $context['_parent'] = $context;
                $context['_seq'] = CoreExtension::ensureTraversable(CoreExtension::getAttribute($this->env, $this->source, ($context["data"] ?? null), "errors", [], "any", false, false, false, 55));
                foreach ($context['_seq'] as $context["_key"] => $context["error"]) {
                    // line 56
                    yield "            <li>";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["error"], "html", null, true);
                    yield "</li>
          ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['error'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 58
                yield "        </ul>
      </div>
    ";
            }
            // line 61
            yield "
    ";
            // line 62
            if ((Twig\Extension\CoreExtension::length($this->env->getCharset(), CoreExtension::getAttribute($this->env, $this->source, ($context["data"] ?? null), "fired", [], "any", false, false, false, 62)) > 0)) {
                // line 63
                yield "      <h4>";
yield _gettext("Possible performance issues");
                yield "</h4>

      <div class=\"accordion mb-4\" id=\"rulesAccordion\">
        ";
                // line 66
                $context['_parent'] = $context;
                $context['_seq'] = CoreExtension::ensureTraversable(CoreExtension::getAttribute($this->env, $this->source, ($context["data"] ?? null), "fired", [], "any", false, false, false, 66));
                $context['loop'] = [
                  'parent' => $context['_parent'],
                  'index0' => 0,
                  'index'  => 1,
                  'first'  => true,
                ];
                if (is_array($context['_seq']) || (is_object($context['_seq']) && $context['_seq'] instanceof \Countable)) {
                    $length = count($context['_seq']);
                    $context['loop']['revindex0'] = $length - 1;
                    $context['loop']['revindex'] = $length;
                    $context['loop']['length'] = $length;
                    $context['loop']['last'] = 1 === $length;
                }
                foreach ($context['_seq'] as $context["_key"] => $context["rule"]) {
                    // line 67
                    yield "          <div class=\"accordion-item\">
            <div class=\"accordion-header\" id=\"heading";
                    // line 68
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["loop"], "index", [], "any", false, false, false, 68), "html", null, true);
                    yield "\">
              <button class=\"accordion-button";
                    // line 69
                    yield (( !CoreExtension::getAttribute($this->env, $this->source, $context["loop"], "first", [], "any", false, false, false, 69)) ? (" collapsed") : (""));
                    yield "\" type=\"button\" data-bs-toggle=\"collapse\" data-bs-target=\"#collapse";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["loop"], "index", [], "any", false, false, false, 69), "html", null, true);
                    yield "\" aria-expanded=\"";
                    yield ((CoreExtension::getAttribute($this->env, $this->source, $context["loop"], "first", [], "any", false, false, false, 69)) ? ("true") : ("false"));
                    yield "\" aria-controls=\"collapse";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["loop"], "index", [], "any", false, false, false, 69), "html", null, true);
                    yield "\">
                ";
                    // line 70
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::striptags(CoreExtension::getAttribute($this->env, $this->source, $context["rule"], "issue", [], "any", false, false, false, 70)), "html", null, true);
                    yield "
              </button>
            </div>
            <div id=\"collapse";
                    // line 73
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["loop"], "index", [], "any", false, false, false, 73), "html", null, true);
                    yield "\" class=\"accordion-collapse collapse";
                    yield ((CoreExtension::getAttribute($this->env, $this->source, $context["loop"], "first", [], "any", false, false, false, 73)) ? (" show") : (""));
                    yield "\" aria-labelledby=\"heading";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["loop"], "index", [], "any", false, false, false, 73), "html", null, true);
                    yield "\" data-bs-parent=\"#rulesAccordion\">
              <div class=\"accordion-body\">
                <dl>
                  <dt>";
yield _gettext("Issue:");
                    // line 76
                    yield "</dt>
                  <dd>";
                    // line 77
                    yield CoreExtension::getAttribute($this->env, $this->source, $context["rule"], "issue", [], "any", false, false, false, 77);
                    yield "</dd>

                  <dt>";
yield _gettext("Recommendation:");
                    // line 79
                    yield "</dt>
                  <dd>";
                    // line 80
                    yield CoreExtension::getAttribute($this->env, $this->source, $context["rule"], "recommendation", [], "any", false, false, false, 80);
                    yield "</dd>

                  <dt>";
yield _gettext("Justification:");
                    // line 82
                    yield "</dt>
                  <dd>";
                    // line 83
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["rule"], "justification", [], "any", false, false, false, 83), "html", null, true);
                    yield "</dd>

                  <dt>";
yield _gettext("Used variable / formula:");
                    // line 85
                    yield "</dt>
                  <dd>";
                    // line 86
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["rule"], "formula", [], "any", false, false, false, 86), "html", null, true);
                    yield "</dd>

                  <dt>";
yield _gettext("Test:");
                    // line 88
                    yield "</dt>
                  <dd>";
                    // line 89
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["rule"], "test", [], "any", false, false, false, 89), "html", null, true);
                    yield "</dd>
                </dl>
              </div>
            </div>
          </div>
        ";
                    ++$context['loop']['index0'];
                    ++$context['loop']['index'];
                    $context['loop']['first'] = false;
                    if (isset($context['loop']['length'])) {
                        --$context['loop']['revindex0'];
                        --$context['loop']['revindex'];
                        $context['loop']['last'] = 0 === $context['loop']['revindex0'];
                    }
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['rule'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 95
                yield "      </div>
    ";
            }
            // line 97
            yield "  ";
        }
        // line 98
        yield "
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "server/status/advisor/index.twig";
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
        return array (  277 => 98,  274 => 97,  270 => 95,  250 => 89,  247 => 88,  241 => 86,  238 => 85,  232 => 83,  229 => 82,  223 => 80,  220 => 79,  214 => 77,  211 => 76,  200 => 73,  194 => 70,  184 => 69,  180 => 68,  177 => 67,  160 => 66,  153 => 63,  151 => 62,  148 => 61,  143 => 58,  134 => 56,  130 => 55,  126 => 53,  122 => 52,  120 => 51,  112 => 45,  106 => 42,  102 => 37,  98 => 32,  94 => 27,  88 => 20,  84 => 19,  73 => 12,  70 => 11,  64 => 9,  62 => 8,  58 => 6,  54 => 5,  50 => 4,  45 => 1,  43 => 2,  36 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "server/status/advisor/index.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\server\\status\\advisor\\index.twig");
    }
}
