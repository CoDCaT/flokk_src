import 'package:flokk/_internal/log.dart';
import 'package:flokk/_internal/utils/string_utils.dart';
import 'package:flokk/commands/abstract_command.dart';
import 'package:flokk/commands/groups/create_label_command.dart';
import 'package:flokk/data/contact_data.dart';
import 'package:flokk/data/group_data.dart';
import 'package:flokk/services/service_result.dart';
import 'package:flutter/cupertino.dart';

class AddLabelToContactCommand extends AbstractCommand with AuthorizedServiceCommandMixin {
  AddLabelToContactCommand(BuildContext c) : super(c);

  Future<List<ContactData>> execute(List<ContactData> contacts, {GroupData existingGroup, String newLabel}) async {
    Log.p("[AddLabelToContactCommand]");
    ServiceResult result;
    await executeAuthServiceCmd(() async {
      GroupData group;
      if (!StringUtils.isEmpty(newLabel)) {
        //create a new label
        group = await CreateLabelCommand(context).execute(newLabel);
      } else if (existingGroup != null) {
        //use existing label
        group = existingGroup;
      }
      if (group != null) {
        result = await googleRestService.groups.modify(authModel.googleAccessToken, group, addContacts: contacts);
      }
      return result?.response;
    });
    return contacts;
  }
}
