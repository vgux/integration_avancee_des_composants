clear all;
close all


% Longueur de la ligne de transmission
L_line = 500e-6; %500e-6;

% Param�tres lin�iques de ligne de transmission  
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
xlabel('Fr�quence (Hz)');
ylabel('Ohms');

figure(12)
plot(Freq,imag(ZC_line));
title('Imaginary ZC-line');
xlabel('Fr�quence (Hz)');
ylabel('Ohms');

figure(13) 
plot(Freq,real(Gamma_line));
title('Real Gamma-line : alpha');
xlabel('Fr�quence (Hz)');
ylabel('Np/m');

figure(14) 
plot(Freq,imag(Gamma_line));
title('Imaginary Gamma-line : beta ');
xlabel('Fr�quence (Hz)');
ylabel('Rad/m');

%----- Fin Question 1 ------------------------------------------------------------------------------%



%----- Question 2 ----------------------------------------------------------------------------------%
% Decommentez et completez

% Lambda = v/f = 2pi/beta

Lambda = (2 .* pi()) ./ imag(Gamma_line);
figure(21) 
plot(Freq,Lambda);
title('Longueur d''onde');
xlabel('Fr�quence (Hz)');
ylabel('m');
%----- Fin Question 2 ------------------------------------------------------------------------------%



%----- Question 3 ----------------------------------------------------------------------------------%
% Decommentez et completez

% Longueur tron�on de ligne  L_T= 250 �m
L_T = L_line / 2;

% Calcul des �l�ments r, l, g, c du mod�le �lectrique d'un tron�on
r = R .* L_T;
l = L .* L_T;
g = G .* L_T;
c = C .* L_T;

% Calcul de Zs et Zp du mod�le �lectrique du tron�on et affichage
Zs = r + i .* l .* Omega;
Zp = 1./ ( g + i .* c .* Omega );

figure(31) 
plot(Freq,real(Zs));
title('Real Zs');
xlabel('Fr�quence (Hz)');
ylabel('Ohms');

figure(32) 
plot(Freq,imag(Zs));
title('Imag Zs');
xlabel('Fr�quence (Hz)');
ylabel('Ohms');

figure(33) 
plot(Freq,real(Zp));
title('Real Zp');
xlabel('Fr�quence (Hz)');
ylabel('Ohms');

figure(34) 
plot(Freq,imag(Zp));
title('Imag Zp');
xlabel('Fr�quence (Hz)');
ylabel('Ohms');


% % Calcul des �l�ments de la matrice ABCD_tron du tron�on
A_tron = (1 + Zs ./ Zp).'; % .' =  passage en vecteur colonne
B_tron = Zs .'; % .' =  passage en vecteur colonne
C_tron = (1 ./ Zp).'; % .' =  passage en vecteur colonne
D_tron = (1.*Freq./Freq).'; % Freq ./ Freq = astuce pour cr�er un vecteur de 1
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
xlabel ('Fr�quence Hz');
ylabel('Np/m');
hold off;

figure(42);
title('Comparaison des Attenuations Beta (Radian/m) ');
plot(Freq,imag(Gamma_line).');
plot(Freq,imag(Gamma_equ));
legend('Beta-line','Beta-equ');
xlabel ('Fr�quence Hz');
ylabel('Rad/m');
hold off;

% Erreur relative en % des parties r�elle et imaginaire qu�il existe entre 
% Gamma_equ et Gamma_line   (Gamma_line �tant la r�f�rence)
ErreurRel_realGamm = ((real(Gamma_equ.') - real(Gamma_line)) ./ real(Gamma_line)) * 100;
ErreurRel_imagGamm = ((imag(Gamma_equ.') - imag(Gamma_line)) ./ imag(Gamma_line)) * 100;

figure(43) 
plot(Freq,ErreurRel_realGamm);
title('Erreur Relative entre parties r�elles de Gamma, Attenuations - %');
xlabel('Fr�quence (Hz)');
ylabel('%');

figure(44) 
plot(Freq,ErreurRel_imagGamm);
title('Erreur Relative entre parties imaginaires de Gamma, Attenuations - %');
xlabel('Fr�quence (Hz)');
ylabel('%');

% Calcul de  ZC_equ
ZC_equ = Zs .* (1./Zp);

% Comparaison de ZC_line et ZC_equ 
figure(45);
hold on;
title('Comparaison des parties r�elles de ZC');
plot(Freq,real(ZC_line));
plot(Freq,real(ZC_equ));
legend('ZC-line','ZC-equ');
xlabel ('Fr�quence Hz');
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
% % Longueur nouveau Tron�on = 1 �m
% L_Tnew  = 1e-6;
% 
% % Nombre de nouveau tron�ons n�cessaires
% NbTron = ................................ ;
% 
% % Calcul des �l�ments r, l, g, c du nouveau mod�le �lectrique d'un tron�on
% r_new= R .* L_Tnew;
% l_new = ....................;
% g_new = ...................;
% c_new= ....................;
% 
% % Calcul de Zs et Zp  du nouveau mod�le �lectrique du tron�on
% Zs_new = r_new + i .* l_new .* Omega;
% Zp_new = .......................................;
% 
% % Calcul des �l�ments de la matrice ABCD_tron du nouveau tron�on
% A_tron_new = (1 + Zs_new ./ Zp_new).'; % .' =  passage en vecteur colonne
% B_tron_new =..............  .'; % .' =  passage en vecteur colonne
% C_tron_new = ............... .'; % .' =  passage en vecteur colonne
% D_tron_new = (1.*Freq./Freq).'; % Freq ./ Freq = astuce pour cr�er un vecteur de 1
% ABCD_tron_new = [ A_tron_new   B_tron_new   C_tron_new   D_tron_new ] ; %
% 
% % Calcul de ABCD_equ_new, nouvelle matrice ABCD �quivalente qui est la cascade de "NbTron" matrices ABCD_tron_new d'un nouveau tron�on 
%  prodMat_temp= ABCD_tron_new ;
%    
%  for i = 1 : (NbTron - 1)
%            %%%% INFO => deux lignes � ecrire
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
% xlabel ('Fr�quence Hz');
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
% title('Comparaison des parties r�elles de ZC');
% plot(Freq,real(ZC_line));
% plot(Freq,real(ZC_equ_new));
% legend('ZC-line','ZC-equ-new');
% xlabel ('Fr�quence Hz');
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