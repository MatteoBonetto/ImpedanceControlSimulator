% rounded_square_path.m
% Genera un percorso (x,y) di un quadrato con spigoli smussati (fillet)
% Uso: [x,y] = roundedSquare(L, r, nLine, nArc)
% Esempio: [x,y] = roundedSquare(10, 2);

function [x,y] = roundedSquare(L, r, nLine, nArc)
    if nargin < 2, r = 2; end            % r di default = 2 m
    if nargin < 3, nLine = 50; end       % punti lungo i segmenti retti
    if nargin < 4, nArc = 30; end        % punti per ogni arco di quartocirconferenza

    if r <= 0
        error('Il raggio r deve essere > 0.')
    end
    if r > L/2
        error('Il raggio r deve essere <= L/2 (troppo grande rispetto al lato).')
    end

    h = L/2; % semilato (centro in origine)
    % Tangenti sui lati (punti iniziali dei segmenti)
    % Ordine percorso: in senso antiorario, partendo dal punto (h-r, h) (tra lato top e angolo top-right)
    % Punti tangenti:
    T_top_right    = [ h - r,  h      ];
    T_top_left     = [-h + r,  h      ];
    T_left_top     = [-h,      h - r  ];
    T_left_bottom  = [-h,     -h + r  ];
    T_bottom_left  = [-h + r, -h      ];
    T_bottom_right = [ h - r, -h      ];
    T_right_bottom = [ h,     -h + r  ];
    T_right_top    = [ h,      h - r  ];

    % Centri degli archi (spostati verso l'interno di r)
    C_TR = [ h - r,  h - r ];  % top-right center
    C_TL = [-h + r,  h - r ];  % top-left center
    C_BL = [-h + r, -h + r ];  % bottom-left center
    C_BR = [ h - r, -h + r ];  % bottom-right center

    % Costruzione percorso: segmenti retti e archi (antiorario)
    x = []; y = [];

    % 1) lato top: da T_top_right a T_top_left
    xs = linspace(T_top_right(1), T_top_left(1), nLine);
    ys = T_top_right(2) * ones(1,length(xs));
    x = [x xs]; y = [y ys];

    % 2) arco top-left: centro C_TL, angoli da pi/2 a pi
    th = linspace(pi/2, pi, nArc);
    x = [x (C_TL(1) + r*cos(th))];
    y = [y (C_TL(2) + r*sin(th))];

    % 3) lato sinistro: da ( -h, h-r ) a ( -h, -h+r )
    xs = -h * ones(1,nLine);
    ys = linspace(T_left_top(2), T_left_bottom(2), nLine);
    x = [x xs]; y = [y ys];

    % 4) arco bottom-left: centro C_BL, angoli da pi a 3*pi/2
    th = linspace(pi, 3*pi/2, nArc);
    x = [x (C_BL(1) + r*cos(th))];
    y = [y (C_BL(2) + r*sin(th))];

    % 5) lato bottom: da (-h+r, -h) a (h-r, -h)
    xs = linspace(T_bottom_left(1), T_bottom_right(1), nLine);
    ys = -h * ones(1,length(xs));
    x = [x xs]; y = [y ys];

    % 6) arco bottom-right: centro C_BR, angoli da 3*pi/2 a 2*pi
    th = linspace(3*pi/2, 2*pi, nArc);
    x = [x (C_BR(1) + r*cos(th))];
    y = [y (C_BR(2) + r*sin(th))];

    % 7) lato destro: da (h, -h+r) a (h, h-r)
    xs = h * ones(1,nLine);
    ys = linspace(T_right_bottom(2), T_right_top(2), nLine);
    x = [x xs]; y = [y ys];

    % 8) arco top-right: centro C_TR, angoli da 0 a pi/2
    th = linspace(0, pi/2, nArc);
    x = [x (C_TR(1) + r*cos(th))];
    y = [y (C_TR(2) + r*sin(th))];

    % Chiudi il percorso ripetendo il primo punto (opzionale)
    x(end+1) = x(1);
    y(end+1) = y(1);
end

% -------------------------
% Esempio di uso (script)
% -------------------------
% L = 10; r = 2;
% [x,y] = roundedSquare(L, r);
% figure; plot(x,y,'-o','LineWidth',1.2); axis equal;
% grid on; title(sprintf('Quadrato smussato: L=%g m, r=%g m',L,r));
