 function  [Mat_Prod, A_,B_,C_,D_] = FCT_Prod_Matrice(Mat1,Mat2)
 
 % cette fonction calcule le produit une matrice m1 (ABCD par exemple) dont les �l�ments sont plac�s en ligne dans une
% matrice de donn�es Mat1 avec une matrice m2  dont les �l�ments sont plac�s en ligne dans une matrice de donn�es Mat2

 
% Les matrices Mat1 et Mat2 doivent �tre de la forme :
%      |   A1   B1  C1  D1   | => matrice ABCD 1 pour une fr�quence F1  donn�e
%      |   A2   B2  C2  D2   | => matrice ABCD 2 pour une fr�quence F2  donn�e
%      ---------------------------
%      ---------------------------
%      ---------------------------
 %     |   AN   BN  CN  DN  | => matrice ABCD N  pour une fr�quence FN  donn�e
 
  
        % Calcul du nombre de ligne de la matrice Mat1
        [N_line,N_col] = size(Mat1); % N = length((Mat1));
 
       % Calul du produit des matrices contenues dans les matrices  Mat1 et Mat2 et mise des Resultats  la matrice Mat_Inv 
        for n = 1 : N_line
          MatABCD_1 = [Mat1(n,1) Mat1(n,2); Mat1(n,3) Mat1(n,4)];
          MatABCD_2 = [Mat2(n,1) Mat2(n,2); Mat2(n,3) Mat2(n,4)];
                   
          MatABCD_DUT = MatABCD_1 *  MatABCD_2;
          
          Mat_Prod(n,:)=[MatABCD_DUT(1,1) MatABCD_DUT(1,2) MatABCD_DUT(2,1) MatABCD_DUT(2,2)];
        end
       
       % Vecteurs constitu�s des �lements A, B, C et D des matrices resultantes pour chaque points de fr�quence     
       A_= Mat_Prod(:,1);
       B_= Mat_Prod(:,2);
       C_= Mat_Prod(:,3);
       D_= Mat_Prod(:,4);   
       
% Exemple de la forme du vecteur A_ qui les �lements A pour chaque points de fr�quence
%      |   A1'   | => El�ment  A de la matrice 1 r�sultante du produit m1 par m2  pour une fr�quence F1  donn�e
%      |   A2'   | => El�ment  A de la matrice 2 r�sultante du produit m1 par m2  pour une fr�quence F2  donn�e
%      ----------
%      ----------
%      ----------
%     |   AN'    | => A de la matrice N r�sultante du produit m1 par m2  pour une fr�quence FN  donn�e
       
       
       
       