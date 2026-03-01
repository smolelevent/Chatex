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

/* preview_sql.twig */
class __TwigTemplate_d6f8c5e7596e58187db5b1d699707228 extends Template
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
        yield "<div class=\"preview_sql\">
    ";
        // line 2
        if (Twig\Extension\CoreExtension::testEmpty(($context["query_data"] ?? null))) {
            // line 3
            yield "        ";
yield _gettext("No change");
            // line 4
            yield "    ";
        } elseif (is_iterable(($context["query_data"] ?? null))) {
            // line 5
            yield "        ";
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["query_data"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["query"]) {
                // line 6
                yield "            ";
                yield PhpMyAdmin\Html\Generator::formatSql($context["query"]);
                yield "
        ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['query'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 8
            yield "    ";
        } else {
            // line 9
            yield "        ";
            yield PhpMyAdmin\Html\Generator::formatSql(($context["query_data"] ?? null));
            yield "
    ";
        }
        // line 11
        yield "</div>
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "preview_sql.twig";
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
        return array (  72 => 11,  66 => 9,  63 => 8,  54 => 6,  49 => 5,  46 => 4,  43 => 3,  41 => 2,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "preview_sql.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\preview_sql.twig");
    }
}
