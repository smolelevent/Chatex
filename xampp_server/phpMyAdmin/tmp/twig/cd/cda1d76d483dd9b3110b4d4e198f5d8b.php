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

/* server/sub_page_header.twig */
class __TwigTemplate_008209dbcf9439ce872a039e5e367154 extends Template
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
        // line 2
        $context["header"] = ["privileges" => ["image" => "b_usrlist", "text" => _gettext("Privileges")]];
        // line 8
        yield "<h2>
    ";
        // line 9
        if (((array_key_exists("is_image", $context)) ? (Twig\Extension\CoreExtension::default(($context["is_image"] ?? null), true)) : (true))) {
            // line 10
            yield "        ";
            yield PhpMyAdmin\Html\Generator::getImage((($__internal_compile_0 = (($__internal_compile_1 = ($context["header"] ?? null)) && is_array($__internal_compile_1) || $__internal_compile_1 instanceof ArrayAccess ? ($__internal_compile_1[($context["type"] ?? null)] ?? null) : null)) && is_array($__internal_compile_0) || $__internal_compile_0 instanceof ArrayAccess ? ($__internal_compile_0["image"] ?? null) : null));
            yield "
    ";
        } else {
            // line 12
            yield "        ";
            yield PhpMyAdmin\Html\Generator::getIcon((($__internal_compile_2 = (($__internal_compile_3 = ($context["header"] ?? null)) && is_array($__internal_compile_3) || $__internal_compile_3 instanceof ArrayAccess ? ($__internal_compile_3[($context["type"] ?? null)] ?? null) : null)) && is_array($__internal_compile_2) || $__internal_compile_2 instanceof ArrayAccess ? ($__internal_compile_2["image"] ?? null) : null));
            yield "
    ";
        }
        // line 14
        yield "    ";
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape((($__internal_compile_4 = (($__internal_compile_5 = ($context["header"] ?? null)) && is_array($__internal_compile_5) || $__internal_compile_5 instanceof ArrayAccess ? ($__internal_compile_5[($context["type"] ?? null)] ?? null) : null)) && is_array($__internal_compile_4) || $__internal_compile_4 instanceof ArrayAccess ? ($__internal_compile_4["text"] ?? null) : null), "html", null, true);
        yield "
    ";
        // line 15
        yield ((array_key_exists("link", $context)) ? (PhpMyAdmin\Html\MySQLDocumentation::show(($context["link"] ?? null))) : (""));
        yield "
</h2>
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "server/sub_page_header.twig";
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
        return array (  62 => 15,  57 => 14,  51 => 12,  45 => 10,  43 => 9,  40 => 8,  38 => 2,);
    }

    public function getSourceContext()
    {
        return new Source("", "server/sub_page_header.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\server\\sub_page_header.twig");
    }
}
