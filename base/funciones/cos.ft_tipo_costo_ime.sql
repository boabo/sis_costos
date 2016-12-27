CREATE OR REPLACE FUNCTION "cos"."ft_tipo_costo_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistemas de Costos
 FUNCION: 		cos.ft_tipo_costo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cos.ttipo_costo'
 AUTOR: 		 (admin)
 FECHA:	        27-12-2016 20:53:14
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_tipo_costo	integer;
			    
BEGIN

    v_nombre_funcion = 'cos.ft_tipo_costo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'COS_TCO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		27-12-2016 20:53:14
	***********************************/

	if(p_transaccion='COS_TCO_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into cos.ttipo_costo(
			codigo,
			nombre,
			sw_trans,
			descripcion,
			id_tipo_costo_fk,
			estado_reg,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.codigo,
			v_parametros.nombre,
			v_parametros.sw_trans,
			v_parametros.descripcion,
			v_parametros.id_tipo_costo_fk,
			'activo',
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_tipo_costo into v_id_tipo_costo;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Clasificacición de Costos almacenado(a) con exito (id_tipo_costo'||v_id_tipo_costo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_costo',v_id_tipo_costo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'COS_TCO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		27-12-2016 20:53:14
	***********************************/

	elsif(p_transaccion='COS_TCO_MOD')then

		begin
			--Sentencia de la modificacion
			update cos.ttipo_costo set
			codigo = v_parametros.codigo,
			nombre = v_parametros.nombre,
			sw_trans = v_parametros.sw_trans,
			descripcion = v_parametros.descripcion,
			id_tipo_costo_fk = v_parametros.id_tipo_costo_fk,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_costo=v_parametros.id_tipo_costo;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Clasificacición de Costos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_costo',v_parametros.id_tipo_costo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'COS_TCO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		27-12-2016 20:53:14
	***********************************/

	elsif(p_transaccion='COS_TCO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from cos.ttipo_costo
            where id_tipo_costo=v_parametros.id_tipo_costo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Clasificacición de Costos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_costo',v_parametros.id_tipo_costo::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "cos"."ft_tipo_costo_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
