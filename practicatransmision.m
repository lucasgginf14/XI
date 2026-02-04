%%%%%%           SISTEMA DE TRANSMISION BANDA BASE         %%%%%%


clear all;
close all;

%=================== Parametros ==================================
N= 20;		 % Periodo de simbolo               velocidad de bit = velocidad de simbolo = 1/N
L= 6;		 % Numero de bits a transmitir
tipopulso= 4; %1: pulso rectangular
EbNo =  3 %esta en dB

%=================== Generacion del pulso =========================

if tipopulso == 1  %pulso rectangular
  n=0:N-1;
  pulso=ones(1,N);
elseif tipopulso == 2 %escriba un elseif por cada tipo
  n=0:N/2-1;
  pulso=ones(1,N/2);
elseif tipopulso == 3
  n=0:N-1;
  a = ones(1,N/2);
  b= -ones(1,N/2);
  pulso = [a b];
elseif tipopulso == 4 %en este caso el periodo debe de ser multiplo de cuatro por estar definido en cuartos (N/4)
  n = 0:N-1;
  pulso = [ones(1,N/4) zeros(1,N/4) zeros(1,N/4) zeros(1,N/4)]
end;


%=================== Calculo de la energia del pulso =============                                           

energia = sum(power(pulso, 2))

%=================== Generacion de la senal (modulacion) =========

bits=rand(1,L) < 0.5;             %genera 0 y 1 a partir de un vector de numeros
                      %aleatorios con distribucion uniforme

s_enviada = [];
for b = bits
   if b == 1
   s_enviada = [s_enviada -pulso];
 else
   s_enviada = [s_enviada pulso];
   endif;
endfor                  

%=================== Generación de señal recibida  =============

%Cambio a unidades naturales y calculo de No
Eb = energia
EbNo=10^(EbNo/10);  
No=Eb/EbNo
ruido=sqrt(No/2)*randn(1,N*L);

recibida = s_enviada + ruido;

%=================== Calculo de la proabilidad de error ===========

pulsoinv = pulso(N:-1:1);
ind = 1;
  
for k = 1:N:L*N-1
  s_conv = conv(recibida(k:k+N-1),pulsoinv);
  s_muest = s_conv(N);
  bits_enviada(ind) = s_muest <= 0;
  
  %if s_muest > 0
  %  bits_enviada(ind) = 0;
  %else
  %  bits_enviada(ind) = 1;
  %end;
  
  ind = ind + 1;
end;

pe_real = mean(bits_enviada ~= bits)
pe_teo = erfc(sqrt(EbNo))/2

%=================== Representacion grafica ===================
figure(1);
plot(n,pulso);
axis([0 N -2 2]);
xlabel('t(s)');
ylabel('Valor');
title('Pulso usado');
grid;

figure(2);

subplot(2,1,1);
plot(0: ((N*L) -1),s_enviada);
axis([0 N*L -2 2]);
xlabel('t(s)');
ylabel('Valor');
title('Señal transmitida');
grid;

subplot(2,1,2);
plot(0: ((N*L) -1),recibida);
axis([0 N*L -4 4]);
xlabel('t(s)');
ylabel('Valor');
title('Señal recibida');
grid;

%utilize title, axis, xlabel e ylabel para ajustarla e identificarla correctamente