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

/* database/structure/tracking_icon.twig */
class __TwigTemplate_b850dfe8081782a8167d9d8878f99248 extends Template
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
        yield "<a href=\"";
        yield PhpMyAdmin\Url::getFromRoute("/table/tracking", ["table" => ($context["table"] ?? null), "db" => ($context["db"] ?? null)]);
        yield "\">
    ";
        // line 2
        if (($context["is_tracked"] ?? null)) {
            // line 3
            yield PhpMyAdmin\Html\Generator::getImage("eye", _gettext("Tracking is active."));
        } else {
            // line 5
            yield PhpMyAdmin\Html\Generator::getImage("eye_grey", _gettext("Tracking is not active."));
        }
        // line 7
        yield "</a>
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "database/structure/tracking_icon.twig";
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
        return array (  51 => 7,  48 => 5,  45 => 3,  43 => 2,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "database/structure/tracking_icon.twig", "C:\\Users\\user\\Desktop\\vizsgahoz szukseges\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\database\\structure\\tracking_icon.twig");
    }
}
