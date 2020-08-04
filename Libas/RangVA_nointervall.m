%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mehrfaktorielle Rangvarainzanalyse mit Messwiederholung  										 %% mittels Datenalignment											 										 %% Vorgehensweise beschrieben in Kapitel 6.2.5.2 in J. Bortz, G. A. Lienert, K. Boehnke. %% Verteilungsfreie Methoden in der Biostatistik. Springer Verlag 1990. S.282-289.       %  %																													 %%									  																			 	 %% Stephan Moratti														 										 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Einlesen der Datenmatrix %clear all;format compact;fprintf('\nMehrfaktorielle Rangvarianzanalyse mit Me�wiederholung\n');fprintf('Stephan Moratti\n');fprintf('\nVorgehensweise beschrieben in Kapitel 6.2.5.2 in J. Bortz, G. A. Lienert, K. Boehnke.\nVerteilungsfreie Methoden in der Biostatistik. Springer Verlag 1990. S.282-289.');fprintf('\n\n');StufenA = input('Wieviel Stufen soll Faktor A besitzen ? ');StufenB = input('Wieviel Stufen soll Faktor B besitzen ? ');N = input('Wieviele Versuchspersonen insgesamt ? ');nA = input('Wieviele Vesuchspersonen pro Faktorstufe in Faktor A (Gruppen m�ssen gleich gross sein) ? ');file = input('Name der Datenmatrix ? ','s');eval(['load ' file]);new = strrep(file,'.txt','');s1 = sprintf('DATA = %s;',new);eval(s1);% Ausgabe des Versuchsplan %fprintf('\nFolgender Versuchsplan :\n\n');fprintf('\t');for i=1:StufenB   fprintf('b%g\t\t',i);end;fprintf('\n\n');DATABILD=reshape(DATA,[nA StufenA StufenB]);DATABILD=runde(DATABILD,10000);% Datenplan zeichnenfor j=1:StufenA  for z=1:nA     fprintf('a%g\t',j);     for y=1:StufenB        fprintf('%g\t\t',DATABILD(z,j,y));     end;     fprintf('\n');  end;  fprintf('\n');end;taste = input('\n\n Weiter mit Return ! ');         datar = reshape(DATA,[1 (N*StufenB)]);[datar,tie,s]=makerank(datar);DATA = reshape(datar,[N StufenB]);% Ausgabe des Versuchsplan nach R�ngen %fprintf('\nFolgender Versuchsplan nach Rangtransformation :\n\n');fprintf('\t');for i=1:StufenB   fprintf('b%g\t\t',i);end;fprintf('\n\n');DATABILD=reshape(DATA,[nA StufenA StufenB]);DATABILD=runde(DATABILD,10000);% Datenplan zeichnenfor j=1:StufenA  for z=1:nA     fprintf('a%g\t',j);     for y=1:StufenB        fprintf('%g\t\t',DATABILD(z,j,y));     end;     fprintf('\n');  end;  fprintf('\n');end;taste = input('\n\n Weiter mit Return ! ');% Berechnung der erforderlichen Mittelwerte f�r die Korrekturen der Effektea = DATA';	%Matrix f�r Mittelwertberechnung der Randzeilen transponierenPm = mean(a); %Pm f�r Personen-Effekte P = sum(a);summe = 0; % A(i) f�r A-Effekte z=1;for k = 1:StufenA	%�nderung	for i = 1:nA   	summe = summe + P(z);    	z = z+1;	end;   A(k) = summe;   summe = 0;end;z=1;		%Am(i) f�r A-Effektemulti = nA * StufenB;for z=1:StufenA	%�nderung2   Am(z) = A(z)/multi;end;B = sum(DATA); % B(i) und Bm(i) f�r B-EffekteBm = B/N;clear a;			% G ung Gm f�r sp�tere Korrektur, damit keine negativen Wertea = B';G = sum(a);multi = N * StufenB;Gm = G/multi;summe = 0;gr=0;for i=1:StufenB	% AB(y,i) und ABm(y,i)f�r AB-Effekte berechnen   for y=1:StufenA      for z=1:nA         summe = summe + DATA((z+gr),i);		end;	            AB(y,i) = summe;      summe = 0;      gr=gr+nA;   end;   gr=0;end;ABm = AB/nA;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Faktor A (ohne Messwiederholung) als abh�ngige Variable einer einfaktoriellen Varianzanalyse %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%[faktorA1,tie,s] = makerank(Pm);		% Aus Vektor Pm Vektor mit R�ngen (Ties) bildenFAKTORA = reshape(faktorA1,[nA StufenA]); %einfaktroiellen Plan f�r Faktor A erstellenTi = sum(FAKTORA);	% Rangsummen pro Faktorstufe in Faktor A bilden   for i=1:length(Ti)      QTi(i) = Ti(i) * Ti(i);   end;      SQTi=sum(QTi);		%Quadratsumme der Rangsummen      for i=1:length(faktorA1);      QRi(i) = faktorA1(i) * faktorA1(i);   end;      SQRi=sum(QRi);      Na = length(faktorA1);   NNa = (Na+1)*(Na+1);   FGa = StufenA-1;      if (tie == 1)				% Falls ein Tie vorliegt aus Rangbildung folgende Formel f�r H verwenden   	Ha = ((Na-1)*((1/nA*SQTi)-(1/4*Na*NNa))/(SQRi-(1/4*Na*NNa)));	% H-Statistik f�r Haupeffekt A berechnen   end;      if (tie == 0)      Ha = ((12*StufenA)/((Na*Na)*(Na+1)))*SQTi-(3*(Na+1)); % Achtung ! Einzelstichproben der Faktorstufen m�ssen gleich gro� sein !   end;   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Faktor B mittels ipsative Messwerte: Datenalignement					%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DATA2=reshape(DATA,[nA StufenA StufenB]);Pm2=reshape(Pm,[nA StufenA]);for i=1:StufenB	% Datenalignment: x'ijm = xijm-Pim-ABij+Ai+Bj (Schreibweise aus dem Buch)   for j=1:StufenA      for z=1:nA         DATAB2(z,j,i) = DATA2(z,j,i)-Pm2(z,j)-ABm(j,i)+Am(j)+Bm(i);      end;   end;end;DATAB = reshape(DATAB2,[N StufenB]);	% Neue Matrix nach Alignementz=1;												% DATAB in eindimesionalen Vektor schreiben f�r makerankfor i=0:(StufenB-1)   for j=1:N      faktorB1(z) = DATAB(j,(i+1));      z=z+1;   end;end;[zwischen,tie,s] = makerank(faktorB1);FAKTORB = reshape(zwischen,[N StufenB]); %FAKTORBTj = sum(FAKTORB);	% Rangsummen pro Faktorstufe des Faktor B   for i=1:length(Tj)      QTj(i) = Tj(i) * Tj(i);   end;          SQTj=sum(QTj);		%Quadratsumme der Rangsummen      for i=1:length(faktorB1);      QRj(i) = zwischen(i) * zwischen(i);   end;      SQRj=sum(QRj);      Nb = length(faktorB1);   NNb = (Nb+1)*(Nb+1);   FGb = StufenB-1;      if (tie == 1)	Hb = ((Nb-1)*((1/N*SQTj)-(1/4*Nb*NNb))/(SQRj-(1/4*Nb*NNb)));	% H-Statistik f�r Haupeffekt B berechnen  	end;      if (tie == 0)      Ha = ((12*StufenB)/((Nb*Nb)*(Nb+1)))*SQTj-(3*(Nb+1)); % Achtung ! Einzelstichproben der Faktorstufen m�ssen gleich gro� sein !   end;      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   % Interaktion AxB ebenfalls mittels ipsativen Me�werten und entsprechendem Datenalignement %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   DATA3 = reshape(DATA,[nA (StufenA*StufenB)]);   z=1;x=1;for i=1:(StufenA*StufenB)     for j=1:nA        DATAAB(j,i) = DATA3(j,i)-Pm2(j,z)-Bm(x)+(2*Gm);           end;     if(z<StufenA)        z=z+1;					%F�r Pm2-Matrix Stufen f�r Faktor A hochz�hlen     else        z=1;        x=x+1;					%wenn alle Stufen von Faktor A bearbeitet sind, wieder     end;						%z�hler zur�cksetzen, damit erneut f�r weiter Stufe des        								%Faktors B alle Stufen von Faktor A durchlaufen werden                                %x hochz�hlen f�r Faktor  end; z=1;												% DATAAB in eindimesionalen Vektor schreiben f�r makerankfor i=0:((StufenA*StufenB)-1)  	for j=1:nA      faktorAB1(z) = DATAAB(j,(i+1));     	z=z+1;  	end;end;[zwischen2,tie,s]=makerank(faktorAB1);FAKTORAB = reshape(zwischen2,[nA (StufenA*StufenB)]);Tij = sum(FAKTORAB);	% Rangsummen pro Faktorstufe des Faktor B   for i=1:length(Tij)      QTij(i) = Tij(i) * Tij(i);   end;          SQTij=sum(QTij);		%Quadratsumme der Rangsummen      for i=1:length(faktorAB1);      QRij(i) = zwischen2(i) * zwischen2(i);   end;      SQRij=sum(QRij);      Nab = length(faktorAB1);   NNab = (Nab+1)*(Nab+1);   pq=StufenA*StufenB;   FGab = (StufenA-1)*(StufenB-1);      if (tie == 1)	Hab = ((Nab-1)*((1/nA*SQTij)-(1/4*Nab*NNab))/(SQRij-(1/4*Nab*NNab)));	% H-Statistik f�r Interaktion AxB berechnen  	end;      if (tie == 0)      Hab = ((12*StufenB*StufenA)/((Nab*Nab)*(Nab+1)))*SQTij-(3*(Nab+1)); % Achtung ! Einzelstichproben der Faktorstufen m�ssen gleich gro� sein !   end;   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sind durch die Rangtransformation k�nstliche Haupteffekte entstanden ? %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%zwischen3 = reshape(Tij,[StufenA StufenB]);R = zwischen3/nA;Rgm = ((StufenA*StufenB)*nA+1)/2;Rjm = mean(R);Rim = mean(R');zwrj = runde(Rjm,10000);	%auf vier Stellen rundenzwri = runde(Rim,10000);R = R';warning=0;for i=1:length(Rjm)				% weichen die Rangmittelwerte von (N+1)/2 ab ?   if(zwrj(i)~=Rgm)      warning = 1;   end;end;if(warning==0)	for i=1:length(Rim)   	if(zwri(i)~=Rgm)      	warning = 1;   	end;   end;end;QR=0;QSR=0;if (warning==1)				% falls ja, dann wird obige Hab-Wert nicht akzeptiert und neu berechnet      for j=1:StufenA      for i=1:StufenB         b(i,j)=R(i,j)-Rim(j)-Rjm(i)+Rgm;         QR = b(i,j)*b(i,j);         QSR = QSR+QR;      end;   end;         Ncorr = length(faktorAB1);   	Hba = 12/(pq*(Nab+1))*QSR; % Hab neu berechnen   if(tie==1)      c1 = s/((Ncorr*Ncorr*Ncorr)-Ncorr);      C = 1-c1;      Hbacorr = Hba/C;			% wenn ties, dann noch Korrektur   end;end;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ausgabe der Pr�fgr��en und anderer relevanter Information 											%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%fprintf('\n');fprintf('F�r Haupteffekt A:		H 		= %g	df = %g\n',Ha,FGa);fprintf('F�r Haupteffekt B:		H 		= %g	df = %g\n\n',Hb,FGb);fprintf('F�r Interaktion AxB		H 		= %g	df = %g\n',Hab,FGab);if (warning==1)   if(tie==1)      fprintf('				Hcorr 		= %g\n',Hbacorr);   else      fprintf('				Hcorr			= %g\n',Hba);   end;   end;taste = input('\n\Weiter mit Return ! ');				% Ausgabe der Rangsummen Haupteffekt Afprintf('\nRangsummen Haupteffekt A:\n\n');for i=1:StufenA   fprintf('Gruppe a%g:	%g	\n',i,Ti(i));end;taste = input('\n\Weiter mit Return ! ');				% Ausgabe der Rangsummen Haupteffekt Bfprintf('\nRangsummen Haupteffekt B:\n\n');for i=1:StufenB   fprintf('Gruppe b%g:	%g\n',i,Tj(i));end;taste = input('\n\Weiter mit Return ! ');			%Ausgabe der Rangsummen Interaktion AxBTijBILD = reshape(Tij,[StufenA StufenB]);fprintf('\nRangsummen der Interaktion AxB:\n\n');for j = 1:StufenB   for i = 1:StufenA      fprintf('b%g:		Gruppe a%g:	%g	Rangdurchschnitt:\t%g\n',j,i,TijBILD(i,j),(TijBILD(i,j)/nA));   end;   %fprintf('\t\t\t\t\tRangmittel-Differenz:	%g\n\n',(TijBILD((i-1),j)/nA)-(TijBILD(i,j)/nA));end;taste = input('\n\Weiter mit Return ! ');%Interaktion plottenz=1;for j = 1:StufenB   for i = 1:StufenA      BildInter(i,j)=TijBILD(i,j)/nA;   	z=z+1;      end;end;figure(1);bildinter = reshape(BildInter,[1 (StufenA*StufenB)]);ymax = max(bildinter);title('Interaktion AxB');hold on;x = 1:StufenB;axis([0 StufenB 0 ymax]);string(1,:)=sprintf('r:square');string(2,:)=sprintf('g:square');string(3,:)=sprintf('b:square');string(4,:)=sprintf('k:square');string(5,:)=sprintf('y:square');string(6,:)=sprintf('m:square');string(7,:)=sprintf('c:square');xlabel('Stufe B');ylabel('Rangmittel');for i=1:StufenA   number(i,:)=sprintf('  a%g',i);end;z=1;for i=1:StufenA   plot(x,BildInter(i,:),string(z,:));   text(StufenB,BildInter(i,StufenB),number(i,:));   z=z+1;   if (z>7) z=1; end;   hold on;end;grid on;hold off;   % Haupteffekt A plottenx = 1:StufenA;figure(2);axis([1 StufenA 0 max(Ti)]);title('Haupteffekt A');hold on;xlabel('Stufe A');ylabel('Rangmittel');plot(x,Ti,'r:square');hold on;grid on;%Haupteffekt B plottenx= 1:StufenB;figure(3);axis([1 StufenB 0 max(Tj)]);title('Haupteffekt B');xlabel('Stufe B');ylabel('Rangmittel');hold on;plot(x,Tj,'r:square');hold ongrid on;