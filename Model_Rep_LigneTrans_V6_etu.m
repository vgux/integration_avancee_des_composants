clear all;
close all


% Longueur de la ligne de transmission
L_line = 500e-6; %500e-6;

% Paramètres linéiques de ligne de transmission  
R = 4000; % Ohms / m
L = 2.7e-7; % Henri / m
G = 0.6; % Siemens / m
C = 1.5e-10; % Farad / m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONSEILS :
% DECOMMENTEZ QUESTION PAR QUESTION ET AU FUR ET A MESURE QU'UNE LIGNE DE
% CODE A TESTER VOUS PARAIT CORRECTE 
% => VERIFIER LE CODE PETIT BOUT PAR PETIT BOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%----- Question 1 ----------------------------------------------------------------------------------%
% Decommentez et completez

Freq_Beginning = 1e9;
Freq_Spacing = 1e9;
Freq_Ending = 120e9;

Freq =  Freq_Beginning:Freq_Spacing:Freq_Ending;
Omega = 2 .* pi() .* Freq;

Gamma_line = sqrt( (R + i .* L.*Omega) .* ( G + i.* C.* Omega) );
ZC_line = sqrt( (R + i .* L.*Omega) ./ ( G + i.* C.* Omega) );


figure(11) 
plot(Freq,real(ZC_line));
title('Real ZC-line');
xlabel('Fréquence (Hz)');
ylabel('Ohms');

figure(12)
plot(Freq,imag(ZC_line));
title('Imaginary ZC-line');
xlabel('Fréquence (Hz)');
ylabel('Ohms');

figure(13) 
plot(Freq,real(Gamma_line));
title('Real Gamma-line : alpha');
xlabel('Fréquence (Hz)');
ylabel('Np/m');

figure(14) 
plot(Freq,imag(Gamma_line));
title('Imaginary Gamma-line : beta ');
xlabel('Fréquence (Hz)');
ylabel('Rad/m');

%----- Fin Question 1 ------------------------------------------------------------------------------%



%----- Question 2 ----------------------------------------------------------------------------------%
% Decommentez et completez

% Lambda = v/f = 2pi/beta

Lambda = (2 .* pi()) ./ imag(Gamma_line);
figure(21) 
plot(Freq,Lambda);
title('Longueur d''onde');
xlabel('Fréquence (Hz)');
ylabel('m');
%----- Fin Question 2 ------------------------------------------------------------------------------%



%----- Question 3 ----------------------------------------------------------------------------------%
% Decommentez et completez

% Longueur tronçon de ligne  L_T= 250 µm
L_T = L_line / 2;

% Calcul des éléments r, l, g, c du modéle électrique d'un tronçon
r = R .* L_T;
l = L .* L_T;
g = G .* L_T;
c = C .* L_T;

% Calcul de Zs et Zp du modéle électrique du tronçon et affichage
Zs = r + i .* l .* Omega;
Zp = 1./ ( g + i .* c .* Omega );

figure(31) 
plot(Freq,real(Zs));
title('Real Zs');
xlabel('Fréquence (Hz)');
ylabel('Ohms');

figure(32) 
plot(Freq,imag(Zs));
title('Imag Zs');
xlabel('Fréquence (Hz)');
ylabel('Ohms');

figure(33) 
plot(Freq,real(Zp));
title('Real Zp');
xlabel('Fréquence (Hz)');
ylabel('Ohms');

figure(34) 
plot(Freq,imag(Zp));
title('Imag Zp');
xlabel('Fréquence (Hz)');
ylabel('Ohms');


% % Calcul des éléments de la matrice ABCD_tron du tronçon
A_tron = (1 + Zs ./ Zp).'; % .' =  passage en vecteur colonne
B_tron = Zs .'; % .' =  passage en vecteur colonne
C_tron = (1 ./ Zp).'; % .' =  passage en vecteur colonne
D_tron = (1.*Freq./Freq).'; % Freq ./ Freq = astuce pour créer un vecteur de 1
ABCD_tron = [ A_tron   B_tron   C_tron   D_tron ] ; %
%----- Fin Question 3 ------------------------------------------------------------------------------%



%----- Question 4 ----------------------------------------------------------------------------------%
% Decommentez et completez

% Calcul de ABCD_equ 
[ABCD_equ, A_equ,B_equ,C_equ,D_equ] = FCT_Prod_Matrice(ABCD_tron, ABCD_tron);

% Calcul de Gamma_equ 
Gamma_equ  = acosh(A_equ) ./ L_line;

% Comparaison de Gamma_line et Gamma_equ 
figure(41);
hold on;
title('Comparaison des Attenuations Alpha (Np/m) ');
plot(Freq,real(Gamma_line.'));
plot(Freq,real(Gamma_equ));
legend('Alpha-line','Alpha-equ');
xlabel ('Fréquence Hz');
ylabel('Np/m');
hold off;

figure(42);
title('Comparaison des Attenuations Beta (Radian/m) ');
plot(Freq,imag(Gamma_line).');
plot(Freq,imag(Gamma_equ));
legend('Beta-line','Beta-equ');
xlabel ('Fréquence Hz');
ylabel('Rad/m');
hold off;

% Erreur relative en % des parties réelle et imaginaire qu’il existe entre 
% Gamma_equ et Gamma_line   (Gamma_line étant la référence)
ErreurRel_realGamm = ((real(Gamma_equ.') - real(Gamma_line)) ./ real(Gamma_line)) * 100;
ErreurRel_imagGamm = ((imag(Gamma_equ.') - imag(Gamma_line)) ./ imag(Gamma_line)) * 100;

figure(43) 
plot(Freq,ErreurRel_realGamm);
title('Erreur Relative entre parties réelles de Gamma, Attenuations - %');
xlabel('Fréquence (Hz)');
ylabel('%');

figure(44) 
plot(Freq,ErreurRel_imagGamm);
title('Erreur Relative entre parties imaginaires de Gamma, Attenuations - %');
xlabel('Fréquence (Hz)');
ylabel('%');

% Calcul de  ZC_equ
ZC_equ = Zs .* (1./Zp);

% Comparaison de ZC_line et ZC_equ 
figure(45);
hold on;
title('Comparaison des parties réelles de ZC');
plot(Freq,real(ZC_line));
plot(Freq,real(ZC_equ));
legend('ZC-line','ZC-equ');
xlabel ('Fréquence Hz');
ylabel('Ohms');
hold off;

% ATTENTION, LIGNE 152 ! bug, il faut qu'il y ai un vecteur colonne


% figure(46);
% 
%
%
%
%
%
%
%----- Fin Question 4 ------------------------------------------------------------------------------%



%----- Question 5 ----------------------------------------------------------------------------------%
% Decommentez et completez
% 
% % Longueur nouveau Tronçon = 1 µm
% L_Tnew  = 1e-6;
% 
% % Nombre de nouveau tronçons nécessaires
% NbTron = ................................ ;
% 
% % Calcul des éléments r, l, g, c du nouveau modéle électrique d'un tronçon
% r_new= R .* L_Tnew;
% l_new = ....................;
% g_new = ...................;
% c_new= ....................;
% 
% % Calcul de Zs et Zp  du nouveau modéle électrique du tronçon
% Zs_new = r_new + i .* l_new .* Omega;
% Zp_new = .......................................;
% 
% % Calcul des éléments de la matrice ABCD_tron du nouveau tronçon
% A_tron_new = (1 + Zs_new ./ Zp_new).'; % .' =  passage en vecteur colonne
% B_tron_new =..............  .'; % .' =  passage en vecteur colonne
% C_tron_new = ............... .'; % .' =  passage en vecteur colonne
% D_tron_new = (1.*Freq./Freq).'; % Freq ./ Freq = astuce pour créer un vecteur de 1
% ABCD_tron_new = [ A_tron_new   B_tron_new   C_tron_new   D_tron_new ] ; %
% 
% % Calcul de ABCD_equ_new, nouvelle matrice ABCD équivalente qui est la cascade de "NbTron" matrices ABCD_tron_new d'un nouveau tronçon 
%  prodMat_temp= ABCD_tron_new ;
%    
%  for i = 1 : (NbTron - 1)
%            %%%% INFO => deux lignes à ecrire
%             .............................................................................
%            .............................................................................
%  end
%       
% % Calcul du nouveau exposant de propagation Gamma_equ 
% Gamma_equ_new = .........................................;
% 
% % Comparaison de Gamma_line et Gamma_equ 
% figure(51);
% hold on;
% title('Comparaison des Attenuations Alpha (Np/m) ');
% plot(Freq,real(Gamma_line));
% plot(Freq,real(Gamma_equ_new));
% legend('Alpha-line','Alpha-equ-new');
% xlabel ('Fréquence Hz');
% ylabel('Np/m');
% hold off;
% 
% figure(52);
%
%
%
%
%
% 
% % Calcul de  ZC_equ_new
% ZC_equ_new= ....................................... ;
% 
% % Comparaison de ZC_line et ZC_equ 
% figure(53);
% hold on;
% title('Comparaison des parties réelles de ZC');
% plot(Freq,real(ZC_line));
% plot(Freq,real(ZC_equ_new));
% legend('ZC-line','ZC-equ-new');
% xlabel ('Fréquence Hz');
% ylabel('Ohms');
% hold off;
% 
% figure(54);
% 
%
%
%
%
%
%----- Fin Question 5 ------------------------------------------------------------------------------%

stop = 1;