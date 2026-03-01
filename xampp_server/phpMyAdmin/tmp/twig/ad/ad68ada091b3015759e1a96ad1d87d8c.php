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

/* server/engines/show.twig */
class __TwigTemplate_8ed98297c2249e739c924508e083f15e extends Template
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
        yield "<h2>
  ";
        // line 2
        yield PhpMyAdmin\Html\Generator::getImage("b_engine");
        yield "
  ";
yield _gettext("Storage engines");
        // line 4
        yield "</h2>

";
        // line 6
        if ( !Twig\Extension\CoreExtension::testEmpty(($context["engine"] ?? null))) {
            // line 7
            yield "  <h2>
    ";
            // line 8
            yield PhpMyAdmin\Html\Generator::getImage("b_engine");
            yield "
    ";
            // line 9
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, ($context["engine"] ?? null), "title", [], "any", false, false, false, 9), "html", null, true);
            yield "
    ";
            // line 10
            yield PhpMyAdmin\Html\MySQLDocumentation::show(CoreExtension::getAttribute($this->env, $this->source, ($context["engine"] ?? null), "help_page", [], "any", false, false, false, 10));
            yield "
  </h2>
  <p><em>";
            // line 12
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, ($context["engine"] ?? null), "comment", [], "any", false, false, false, 12), "html", null, true);
            yield "</em></p>

  ";
            // line 14
            if (( !Twig\Extension\CoreExtension::testEmpty(CoreExtension::getAttribute($this->env, $this->source, ($context["engine"] ?? null), "info_pages", [], "any", false, false, false, 14)) && is_iterable(CoreExtension::getAttribute($this->env, $this->source, ($context["engine"] ?? null), "info_pages", [], "any", false, false, false, 14)))) {
                // line 15
                yield "    <p>
      <strong>[</strong>
      ";
                // line 17
                if (Twig\Extension\CoreExtension::testEmpty(($context["page"] ?? null))) {
                    // line 18
                    yield "        <strong>";
yield _gettext("Variables");
                    yield "</strong>
      ";
                } else {
                    // line 20
                    yield "        <a href=\"";
                    yield PhpMyAdmin\Url::getFromRoute(("/server/engines/" . CoreExtension::getAttribute($this->env, $this->source, ($context["engine"] ?? null), "engine", [], "any", false, false, false, 20)));
                    yield "\">
          ";
yield _gettext("Variables");
                    // line 22
                    yield "        </a>
      ";
                }
                // line 24
                yield "      ";
                $context['_parent'] = $context;
                $context['_seq'] = CoreExtension::ensureTraversable(CoreExtension::getAttribute($this->env, $this->source, ($context["engine"] ?? null), "info_pages", [], "any", false, false, false, 24));
                foreach ($context['_seq'] as $context["current"] => $context["label"]) {
                    // line 25
                    yield "        <strong>|</strong>
        ";
                    // line 26
                    if ((array_key_exists("page", $context) && (($context["page"] ?? null) == $context["current"]))) {
                        // line 27
                        yield "          <strong>";
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["label"], "html", null, true);
                        yield "</strong>
        ";
                    } else {
                        // line 29
                        yield "          <a href=\"";
                        yield PhpMyAdmin\Url::getFromRoute(((("/server/engines/" . CoreExtension::getAttribute($this->env, $this->source, ($context["engine"] ?? null), "engine", [], "any", false, false, false, 29)) . "/") . $context["current"]));
                        yield "\">
            ";
                        // line 30
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["label"], "html", null, true);
                        yield "
          </a>
        ";
                    }
                    // line 33
                    yield "      ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['current'], $context['label'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 34
                yield "      <strong>]</strong>
    </p>
  ";
            }
            // line 37
            yield "
  ";
            // line 38
            if ( !Twig\Extension\CoreExtension::testEmpty(CoreExtension::getAttribute($this->env, $this->source, ($context["engine"] ?? null), "page", [], "any", false, false, false, 38))) {
                // line 39
                yield "    ";
                yield CoreExtension::getAttribute($this->env, $this->source, ($context["engine"] ?? null), "page", [], "any", false, false, false, 39);
                yield "
  ";
            } else {
                // line 41
                yield "    <p>";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, ($context["engine"] ?? null), "support", [], "any", false, false, false, 41), "html", null, true);
                yield "</p>
    ";
                // line 42
                yield CoreExtension::getAttribute($this->env, $this->source, ($context["engine"] ?? null), "variables", [], "any", false, false, false, 42);
                yield "
  ";
            }
        } else {
            // line 45
            yield "  <p>";
            yield $this->env->getFilter('error')->getCallable()(_gettext("Unknown storage engine."));
            yield "</p>
";
        }
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "server/engines/show.twig";
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
        return array (  157 => 45,  151 => 42,  146 => 41,  140 => 39,  138 => 38,  135 => 37,  130 => 34,  124 => 33,  118 => 30,  113 => 29,  107 => 27,  105 => 26,  102 => 25,  97 => 24,  93 => 22,  87 => 20,  81 => 18,  79 => 17,  75 => 15,  73 => 14,  68 => 12,  63 => 10,  59 => 9,  55 => 8,  52 => 7,  50 => 6,  46 => 4,  41 => 2,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "server/engines/show.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\server\\engines\\show.twig");
    }
}
