{ config, lib, ... }:
let
  cfg = config.wofi;
in
{
  options.wofi = with lib; {
    theme = mkOption {
      type = types.enum [ "light" "dark" ];  
    };

    font = mkOption {
      type = hm.types.fontType;
      default = {
        name = "consolas";
        size = 10;
      };
    };

    latte = mkOption {
      readOnly = true;
      type = types.str;
      default = ''
        @define-color	rosewater  #dc8a78;
        @define-color	rosewater-rgb  rgb(220, 138, 120);
        @define-color	flamingo  #dd7878;
        @define-color	flamingo-rgb  rgb(221, 120, 120);
        @define-color	pink  #ea76cb;
        @define-color	pink-rgb  rgb(234, 118, 203);
        @define-color	mauve  #8839ef;
        @define-color	mauve-rgb  rgb(136, 57, 239);
        @define-color	red  #d20f39;
        @define-color	red-rgb  rgb(210, 15, 57);
        @define-color	maroon  #e64553;
        @define-color	maroon-rgb  rgb(230, 69, 83);
        @define-color	peach  #fe640b;
        @define-color	peach-rgb  rgb(254, 100, 11);
        @define-color	yellow  #df8e1d;
        @define-color	yellow-rgb  rgb(223, 142, 29);
        @define-color	green  #40a02b;
        @define-color	green-rgb  rgb(64, 160, 43);
        @define-color	teal  #179299;
        @define-color	teal-rgb  rgb(23, 146, 153);
        @define-color	sky  #04a5e5;
        @define-color	sky-rgb  rgb(4, 165, 229);
        @define-color	sapphire  #209fb5;
        @define-color	sapphire-rgb  rgb(32, 159, 181);
        @define-color	blue  #1e66f5;
        @define-color	blue-rgb  rgb(30, 102, 245);
        @define-color	lavender  #7287fd;
        @define-color	lavender-rgb  rgb(114, 135, 253);
        @define-color	text  #4c4f69;
        @define-color	text-rgb  rgb(76, 79, 105);
        @define-color	subtext1  #5c5f77;
        @define-color	subtext1-rgb  rgb(92, 95, 119);
        @define-color	subtext0  #6c6f85;
        @define-color	subtext0-rgb  rgb(108, 111, 133);
        @define-color	overlay2  #7c7f93;
        @define-color	overlay2-rgb  rgb(124, 127, 147);
        @define-color	overlay1  #8c8fa1;
        @define-color	overlay1-rgb  rgb(140, 143, 161);
        @define-color	overlay0  #9ca0b0;
        @define-color	overlay0-rgb  rgb(156, 160, 176);
        @define-color	surface2  #acb0be;
        @define-color	surface2-rgb  rgb(172, 176, 190);
        @define-color	surface1  #bcc0cc;
        @define-color	surface1-rgb  rgb(188, 192, 204);
        @define-color	surface0  #ccd0da;
        @define-color	surface0-rgb  rgb(204, 208, 218);
        @define-color	base  #eff1f5;
        @define-color	base-rgb  rgb(239, 241, 245);
        @define-color	mantle  #e6e9ef;
        @define-color	mantle-rgb  rgb(230, 233, 239);
        @define-color	crust  #dce0e8;
        @define-color	crust-rgb  rgb(220, 224, 232);
         
        * {
            font-family: "${cfg.font.name}";
            font-size: ${toString cfg.font.size}px;
        }
         
        /* Window */
        window {
          margin: 0px;
          padding: 10px;
          border: 0.16em solid @lavender;
          border-radius: 0.1em;
          background-color: @base;
          animation: slideIn 0.5s ease-in-out both;
        }
         
        /* Slide In */
        @keyframes slideIn {
          0% {
              opacity: 0;
          }
         
          100% {
              opacity: 1;
          }
        }
         
        /* Inner Box */
        #inner-box {
          margin: 5px;
          padding: 10px;
          border: none;
          background-color: @base;
          animation: fadeIn 0.5s ease-in-out both;
        }
         
        /* Fade In */
        @keyframes fadeIn {
          0% {
              opacity: 0;
          }
         
          100% {
              opacity: 1;
          }
        }
         
        /* Outer Box */
        #outer-box {
          margin: 5px;
          padding: 10px;
          border: none;
          background-color: @base;
        }
         
        /* Scroll */
        #scroll {
          margin: 0px;
          padding: 10px;
          border: none;
          background-color: @base;
        }
         
        /* Input */
        #input {
          margin: 5px 20px;
          padding: 10px;
          border: none;
          border-radius: 0.1em;
          color: @text;
          background-color: @base;
          animation: fadeIn 0.5s ease-in-out both;
        }
         
        #input image {
            border: none;
            color: @red;
        }
         
        #input * {
          outline: 4px solid @red!important;
        }
         
        /* Text */
        #text {
          margin: 5px;
          border: none;
          color: @text;
          animation: fadeIn 0.5s ease-in-out both;
        }
         
        #entry {
          background-color: @base;
        }
         
        #entry arrow {
          border: none;
          color: @lavender;
        }
         
        /* Selected Entry */
        #entry:selected {
          border: 0.11em solid @lavender;
        }
         
        #entry:selected #text {
          color: @mauve;
        }
         
        #entry:drop(active) {
          background-color: @lavender!important;
        }
      '';
    };

    frappe = mkOption {
      readOnly = true;
      type = types.str;
      default = ''
        @define-color	rosewater  #f2d5cf;
        @define-color	rosewater-rgb  rgb(242, 213, 207);
        @define-color	flamingo  #eebebe;
        @define-color	flamingo-rgb  rgb(238, 190, 190);
        @define-color	pink  #f4b8e4;
        @define-color	pink-rgb  rgb(244, 184, 228);
        @define-color	mauve  #ca9ee6;
        @define-color	mauve-rgb  rgb(202, 158, 230);
        @define-color	red  #e78284;
        @define-color	red-rgb  rgb(231, 130, 132);
        @define-color	maroon  #ea999c;
        @define-color	maroon-rgb  rgb(234, 153, 156);
        @define-color	peach  #ef9f76;
        @define-color	peach-rgb  rgb(239, 159, 118);
        @define-color	yellow  #e5c890;
        @define-color	yellow-rgb  rgb(229, 200, 144);
        @define-color	green  #a6d189;
        @define-color	green-rgb  rgb(166, 209, 137);
        @define-color	teal  #81c8be;
        @define-color	teal-rgb  rgb(129, 200, 190);
        @define-color	sky  #99d1db;
        @define-color	sky-rgb  rgb(153, 209, 219);
        @define-color	sapphire  #85c1dc;
        @define-color	sapphire-rgb  rgb(133, 193, 220);
        @define-color	blue  #8caaee;
        @define-color	blue-rgb  rgb(140, 170, 238);
        @define-color	lavender  #babbf1;
        @define-color	lavender-rgb  rgb(186, 187, 241);
        @define-color	text  #c6d0f5;
        @define-color	text-rgb  rgb(198, 208, 245);
        @define-color	subtext1  #b5bfe2;
        @define-color	subtext1-rgb  rgb(181, 191, 226);
        @define-color	subtext0  #a5adce;
        @define-color	subtext0-rgb  rgb(165, 173, 206);
        @define-color	overlay2  #949cbb;
        @define-color	overlay2-rgb  rgb(148, 156, 187);
        @define-color	overlay1  #838ba7;
        @define-color	overlay1-rgb  rgb(131, 139, 167);
        @define-color	overlay0  #737994;
        @define-color	overlay0-rgb  rgb(115, 121, 148);
        @define-color	surface2  #626880;
        @define-color	surface2-rgb  rgb(98, 104, 128);
        @define-color	surface1  #51576d;
        @define-color	surface1-rgb  rgb(81, 87, 109);
        @define-color	surface0  #414559;
        @define-color	surface0-rgb  rgb(65, 69, 89);
        @define-color	base  #303446;
        @define-color	base-rgb  rgb(48, 52, 70);
        @define-color	mantle  #292c3c;
        @define-color	mantle-rgb  rgb(41, 44, 60);
        @define-color	crust  #232634;
        @define-color	crust-rgb  rgb(35, 38, 52);
        
        * {
            font-family: "${cfg.font.name}";
            font-size: ${toString cfg.font.size}px;
        }
        
        /* Window */
        window {
          margin: 0px;
          padding: 10px;
          border: 0.16em solid @lavender;
          border-radius: 0.1em;
          background-color: @base;
          animation: slideIn 0.5s ease-in-out both;
        }
        
        /* Slide In */
        @keyframes slideIn {
          0% {
             opacity: 0;
          }
        
          100% {
             opacity: 1;
          }
        }
        
        /* Inner Box */
        #inner-box {
          margin: 5px;
          padding: 10px;
          border: none;
          background-color: @base;
          animation: fadeIn 0.5s ease-in-out both;
        }
        
        /* Fade In */
        @keyframes fadeIn {
          0% {
             opacity: 0;
          }
        
          100% {
             opacity: 1;
          }
        }
        
        /* Outer Box */
        #outer-box {
          margin: 5px;
          padding: 10px;
          border: none;
          background-color: @base;
        }
        
        /* Scroll */
        #scroll {
          margin: 0px;
          padding: 10px;
          border: none;
          background-color: @base;
        }
        
        /* Input */
        #input {
          margin: 5px 20px;
          padding: 10px;
          border: none;
          border-radius: 0.1em;
          color: @text;
          background-color: @base;
          animation: fadeIn 0.5s ease-in-out both;
        }
        
        #input image {
            border: none;
            color: @red;
        }
        
        #input * {
          outline: 4px solid @red!important;
        }
        
        /* Text */
        #text {
          margin: 5px;
          border: none;
          color: @text;
          animation: fadeIn 0.5s ease-in-out both;
        }
        
        #entry {
          background-color: @base;
        }
        
        #entry arrow {
          border: none;
          color: @lavender;
        }
        
        /* Selected Entry */
        #entry:selected {
          border: 0.11em solid @lavender;
        }
        
        #entry:selected #text {
          color: @mauve;
        }
        
        #entry:drop(active) {
          background-color: @lavender!important;
        }
      '';
    };
  };
  
  config = {
    programs.wofi = {
      enable = true;
      
      settings = {
        key_up = "Ctrl-p";
        key_down = "Ctrl-n";
      };

      style = {
        "light" = cfg.latte;
        "dark" = cfg.frappe;
      }."${cfg.theme}";
    };
  };
}
