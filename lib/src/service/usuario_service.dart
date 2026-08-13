import 'package:app_expedicao/src/model/usuario_consulta.dart';
import 'package:app_expedicao/src/repository/usuario/usuario_consulta_repository.dart';
import 'package:app_expedicao/src/repository/usuario/usuario_repository.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/model/usuario.model.dart';

class UsuarioService {
  UsuarioService();

  static Future<UsuarioModel?> select(int codUsuario) async {
    final usuarioRep = UsuarioRepository();
    final result = await usuarioRep
        .select(QueryBuilder().equals('CodUsuario', codUsuario));
    if (result.isEmpty) return null;
    return result.first;
  }

  static Future<UsuarioConsultaMoldel?> selectConsulta(int codUsuario) async {
    final usuarioConsultaRep = UsuarioConsultaRepository();
    final result = await usuarioConsultaRep
        .select(QueryBuilder().equals('CodUsuario', codUsuario));
    if (result.isEmpty) return null;
    return result.first;
  }
}
