<?php

namespace App\Conroller;

use Symfony\Component\HttpFoundation\Response;

class TryController 
{
    public function index() {
        return new Response(
            '<html><body> this is index page </body></html>'
        );
    }
}
